import React, { useEffect, useState } from 'react';
import { supabase, Building, BuildingDetails } from '../lib/supabase';
import { Bar, Pie } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement,
} from 'chart.js';

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement
);

interface CombinedBuildingData extends Building {
  details?: BuildingDetails;
}

function Analytics() {
  const [buildings, setBuildings] = useState<CombinedBuildingData[]>([]);

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

  // Prepare data for charts
  const buildingsByFloors = buildings.reduce((acc, building) => {
    const floors = building.details?.floors || 0;
    acc[floors] = (acc[floors] || 0) + 1;
    return acc;
  }, {} as Record<number, number>);

  const energyRanges = {
    '0-100k': 0,
    '100k-200k': 0,
    '200k-300k': 0,
    '300k-400k': 0,
    '400k+': 0,
  };

  buildings.forEach(building => {
    const energy = building.details?.energy_consumption || 0;
    if (energy < 100000) energyRanges['0-100k']++;
    else if (energy < 200000) energyRanges['100k-200k']++;
    else if (energy < 300000) energyRanges['200k-300k']++;
    else if (energy < 400000) energyRanges['300k-400k']++;
    else energyRanges['400k+']++;
  });

  const barChartData = {
    labels: Object.keys(buildingsByFloors),
    datasets: [
      {
        label: 'Number of Buildings',
        data: Object.values(buildingsByFloors),
        backgroundColor: 'rgba(59, 130, 246, 0.5)',
        borderColor: 'rgb(59, 130, 246)',
        borderWidth: 1,
      },
    ],
  };

  const pieChartData = {
    labels: Object.keys(energyRanges),
    datasets: [
      {
        data: Object.values(energyRanges),
        backgroundColor: [
          'rgba(59, 130, 246, 0.5)',
          'rgba(16, 185, 129, 0.5)',
          'rgba(245, 158, 11, 0.5)',
          'rgba(239, 68, 68, 0.5)',
          'rgba(139, 92, 246, 0.5)',
        ],
        borderColor: [
          'rgb(59, 130, 246)',
          'rgb(16, 185, 129)',
          'rgb(245, 158, 11)',
          'rgb(239, 68, 68)',
          'rgb(139, 92, 246)',
        ],
        borderWidth: 1,
      },
    ],
  };

  const top10Buildings = [...buildings]
    .sort((a, b) => (b.details?.energy_consumption || 0) - (a.details?.energy_consumption || 0))
    .slice(0, 10);

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Analytics</h1>
      
      <div className="grid grid-cols-2 gap-6 mb-6">
        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-lg font-semibold mb-4">Buildings by Number of Floors</h2>
          <Bar data={barChartData} options={{ maintainAspectRatio: false }} height={300} />
        </div>
        
        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-lg font-semibold mb-4">Energy Consumption Distribution</h2>
          <Pie data={pieChartData} options={{ maintainAspectRatio: false }} height={300} />
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-md p-6">
        <h2 className="text-lg font-semibold mb-4">Top 10 Buildings by Energy Consumption</h2>
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Rank</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Building Name</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Energy Consumption (kWh)</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Floors</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Area (m²)</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {top10Buildings.map((building, index) => (
                <tr key={building.id}>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{index + 1}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{building.name}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {building.details?.energy_consumption.toLocaleString()}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{building.details?.floors}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {building.details?.area.toLocaleString()}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default Analytics;