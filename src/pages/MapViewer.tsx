import React, { useEffect, useState } from 'react';
import Map, { Marker, Popup } from 'react-map-gl';
// import Map from 'react-map-gl';
import { supabase, Building, BuildingDetails } from '../lib/supabase';
import { Slider } from '../components/Slider';
import 'mapbox-gl/dist/mapbox-gl.css';

interface CombinedBuildingData extends Building {
  details?: BuildingDetails;
}

function MapViewer() {
  const [buildings, setBuildings] = useState<CombinedBuildingData[]>([]);
  const [selectedBuilding, setSelectedBuilding] = useState<CombinedBuildingData | null>(null);
  const [floorFilter, setFloorFilter] = useState<number | ''>('');
  const [energyRange, setEnergyRange] = useState<[number, number]>([0, 500000]);
  const [viewState, setViewState] = useState({
    latitude: 53.4084,
    longitude: -2.9916,
    zoom: 13
  });

  useEffect(() => {
    loadBuildings();
  }, []);

  const loadBuildings = async () => {
    const { data, error } = await supabase
      .from('buildings')
      .select('*, details:building_details(*)');

    if (error) {
      console.error('Error loading buildings:', error);
      return;
    }

    const formattedData = data?.map(building => ({
      ...building,
      details: building.details ? building.details[0] : undefined
    })) || [];

    setBuildings(formattedData);
  };

  const filteredBuildings = buildings.filter(building => {
    const details = building.details;
    if (!details) return false;

    const matchesFloors = floorFilter === '' || details.floors === Number(floorFilter);
    const matchesEnergy = details.energy_consumption >= energyRange[0] && 
                         details.energy_consumption <= energyRange[1];

    return matchesFloors && matchesEnergy;
  });

  return (
    <div className="p-6 h-full">
      <div className="bg-white rounded-lg shadow-md p-4 mb-4">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Filter by Floors
            </label>
            <select
              value={floorFilter}
              onChange={(e) => setFloorFilter(e.target.value === '' ? '' : Number(e.target.value))}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            >
              <option value="">All</option>
              {Array.from(new Set(buildings.map(b => b.details?.floors).filter(Boolean))).sort((a, b) => (a || 0) - (b || 0)).map(floors => (
                <option key={floors} value={floors}>{floors} floors</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Energy Consumption Range (kWh)
            </label>
            <Slider
              min={0}
              max={500000}
              step={10000}
              value={energyRange}
              onChange={setEnergyRange}
            />
          </div>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-md h-[calc(100vh-13rem)] overflow-hidden">
        <Map
          {...viewState}
          onMove={evt => setViewState(evt.viewState)}
          mapStyle="mapbox://styles/mapbox/light-v11"
          mapboxAccessToken="pk.eyJ1IjoiZ2FyZXRobWQiLCJhIjoiY2wzb2pham5pMG40NTNrbnl0ZGpxZTh6eSJ9.ef88k_urAZPGIcXkxykv8Q"
        >
          {filteredBuildings.map((building) => (
            <Marker
              key={building.id}
              latitude={building.latitude}
              longitude={building.longitude}
              onClick={e => {
                e.originalEvent.stopPropagation();
                setSelectedBuilding(building);
              }}
            >
              <div 
                className="w-6 h-6 bg-blue-500 rounded-full border-2 border-white shadow-lg cursor-pointer hover:bg-blue-600 transition-colors"
                title={building.name}
              />
            </Marker>
          ))}

          {selectedBuilding && (
            <Popup
              latitude={selectedBuilding.latitude}
              longitude={selectedBuilding.longitude}
              onClose={() => setSelectedBuilding(null)}
              closeButton={true}
              closeOnClick={false}
              className="min-w-[200px]"
            >
              <div className="p-2">
                <h3 className="font-semibold text-lg mb-2">{selectedBuilding.name}</h3>
                <div className="space-y-1 text-sm">
                  <p>Height: {selectedBuilding.details?.height}m</p>
                  <p>Area: {selectedBuilding.details?.area}m²</p>
                  <p>Floors: {selectedBuilding.details?.floors}</p>
                  <p>Energy: {selectedBuilding.details?.energy_consumption.toLocaleString()} kWh</p>
                </div>
              </div>
            </Popup>
          )}
        </Map>
      </div>
    </div>
  );
}

export default MapViewer;