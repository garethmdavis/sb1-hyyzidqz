import React, { useEffect, useState } from 'react';
import { useAuthStore } from '../store/authStore';
import { supabase, Building, BuildingDetails } from '../lib/supabase';
import { Plus, Save, Undo2 } from 'lucide-react';

interface CombinedBuildingData extends Building {
  details?: BuildingDetails;
}

function DataManagement() {
  const { userRole, userId } = useAuthStore();
  const [buildings, setBuildings] = useState<CombinedBuildingData[]>([]);
  const [selectedBuilding, setSelectedBuilding] = useState<CombinedBuildingData | null>(null);
  const [formData, setFormData] = useState<Partial<BuildingDetails>>({});
  const [initialFormData, setInitialFormData] = useState<Partial<BuildingDetails>>({});
  const [newBuildingName, setNewBuildingName] = useState('');
  const [initialBuildingName, setInitialBuildingName] = useState('');
  const [isAddingNew, setIsAddingNew] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  const isEditable = userRole === 'contributor' || userRole === 'admin';

  useEffect(() => {
    loadBuildings();
  }, []);

  const loadBuildings = async () => {
    try {
      const { data: buildingsData, error: buildingsError } = await supabase
        .from('buildings')
        .select('*, details:building_details(*)')
        .order('name');

      if (buildingsError) {
        console.error('Error loading buildings:', buildingsError);
        setError('Failed to load buildings');
        return;
      }

      const formattedData = buildingsData?.map(building => ({
        ...building,
        details: building.details ? building.details[0] : undefined
      })) || [];

      setBuildings(formattedData);
      setError(null);
    } catch (err) {
      console.error('Error in loadBuildings:', err);
      setError('An unexpected error occurred');
    }
  };

  const handleBuildingSelect = (building: CombinedBuildingData) => {
    setSelectedBuilding(building);
    const details = building.details || {};
    setFormData(details);
    setInitialFormData(details);
    setIsAddingNew(false);
    setError(null);
    setSuccessMessage(null);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: name === 'floors' ? parseInt(value) : parseFloat(value)
    }));
    setSuccessMessage(null);
  };

  const hasChanges = () => {
    if (isAddingNew) {
      return newBuildingName !== initialBuildingName || 
             Object.keys(formData).some(key => formData[key as keyof BuildingDetails] !== undefined);
    }
    return JSON.stringify(formData) !== JSON.stringify(initialFormData);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!userId) return;

    try {
      if (isAddingNew) {
        // Create new building
        const { data: newBuilding, error: buildingError } = await supabase
          .from('buildings')
          .insert({
            name: newBuildingName,
            created_by: userId,
            updated_by: userId,
          })
          .select()
          .single();

        if (buildingError) {
          console.error('Error creating building:', buildingError);
          setError('Failed to create building');
          return;
        }

        // Create building details
        if (newBuilding) {
          const { error: detailsError } = await supabase
            .from('building_details')
            .insert({
              ...formData,
              building_id: newBuilding.id,
              created_by: userId,
              updated_by: userId,
            });

          if (detailsError) {
            console.error('Error creating building details:', detailsError);
            setError('Failed to create building details');
            return;
          }
        }
        setSuccessMessage('Building created successfully');
      } else if (selectedBuilding) {
        // Update existing building details
        const { error } = await supabase
          .from('building_details')
          .upsert({
            ...formData,
            building_id: selectedBuilding.id,
            updated_by: userId,
            created_by: selectedBuilding.details?.created_by || userId,
          });

        if (error) {
          console.error('Error updating building details:', error);
          setError('Failed to update building details');
          return;
        }
        setSuccessMessage('Building details updated successfully');
      }

      await loadBuildings();
      if (isAddingNew) {
        setIsAddingNew(false);
        setNewBuildingName('');
        setInitialBuildingName('');
      }
      setInitialFormData(formData);
      setError(null);
    } catch (err) {
      console.error('Error in handleSubmit:', err);
      setError('An unexpected error occurred');
    }
  };

  const handleUndo = () => {
    if (isAddingNew) {
      setFormData({});
      setNewBuildingName('');
      setInitialBuildingName('');
    } else if (selectedBuilding) {
      setFormData(selectedBuilding.details || {});
    }
    setError(null);
    setSuccessMessage(null);
  };

  const startNewBuilding = () => {
    setIsAddingNew(true);
    setSelectedBuilding(null);
    setFormData({});
    setInitialFormData({});
    setNewBuildingName('');
    setInitialBuildingName('');
    setError(null);
    setSuccessMessage(null);
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Building Data Management</h1>

      {error && (
        <div className="mb-4 p-4 bg-red-50 text-red-700 rounded-md">
          {error}
        </div>
      )}

      {successMessage && (
        <div className="mb-4 p-4 bg-green-50 text-green-700 rounded-md">
          {successMessage}
        </div>
      )}

      <div className="grid grid-cols-12 gap-6">
        <div className="col-span-4">
          <div className="bg-white rounded-lg shadow-md p-4">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-lg font-semibold">Buildings</h2>
              {isEditable && (
                <button
                  onClick={startNewBuilding}
                  className="p-2 text-blue-600 hover:bg-blue-50 rounded-full"
                  title="Add new building"
                >
                  <Plus className="w-5 h-5" />
                </button>
              )}
            </div>
            <div className="space-y-2">
              {buildings.map((building) => (
                <button
                  key={building.id}
                  onClick={() => handleBuildingSelect(building)}
                  className={`w-full text-left p-3 rounded-md transition-colors ${
                    selectedBuilding?.id === building.id
                      ? 'bg-blue-50 text-blue-700'
                      : 'hover:bg-gray-50'
                  }`}
                >
                  {building.name}
                </button>
              ))}
            </div>
          </div>
        </div>

        <div className="col-span-8">
          {(selectedBuilding || isAddingNew) ? (
            <div className="bg-white rounded-lg shadow-md p-6">
              <h2 className="text-lg font-semibold mb-4">
                {isAddingNew ? 'New Building' : selectedBuilding?.name} - Details
              </h2>
              <form onSubmit={handleSubmit} className="space-y-4">
                {isAddingNew && (
                  <div className="mb-4">
                    <label className="block text-sm font-medium text-gray-700">
                      Building Name
                    </label>
                    <input
                      type="text"
                      value={newBuildingName}
                      onChange={(e) => {
                        setNewBuildingName(e.target.value);
                        setSuccessMessage(null);
                      }}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                      required
                    />
                  </div>
                )}
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700">
                      Height (m)
                    </label>
                    <input
                      type="number"
                      name="height"
                      value={formData.height || ''}
                      onChange={handleInputChange}
                      disabled={!isEditable}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700">
                      Area (m²)
                    </label>
                    <input
                      type="number"
                      name="area"
                      value={formData.area || ''}
                      onChange={handleInputChange}
                      disabled={!isEditable}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700">
                      Floors
                    </label>
                    <input
                      type="number"
                      name="floors"
                      value={formData.floors || ''}
                      onChange={handleInputChange}
                      disabled={!isEditable}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700">
                      Energy Consumption (kWh)
                    </label>
                    <input
                      type="number"
                      name="energy_consumption"
                      value={formData.energy_consumption || ''}
                      onChange={handleInputChange}
                      disabled={!isEditable}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                    />
                  </div>
                </div>

                {isEditable && hasChanges() && (
                  <div className="flex justify-end space-x-3 pt-4">
                    <button
                      type="button"
                      onClick={handleUndo}
                      className="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
                    >
                      <Undo2 className="w-4 h-4 mr-2" />
                      Undo Changes
                    </button>
                    <button
                      type="submit"
                      className="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
                    >
                      <Save className="w-4 h-4 mr-2" />
                      Save Changes
                    </button>
                  </div>
                )}
              </form>
            </div>
          ) : (
            <div className="bg-white rounded-lg shadow-md p-6 flex items-center justify-center text-gray-500">
              Select a building to view and edit its details
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default DataManagement;