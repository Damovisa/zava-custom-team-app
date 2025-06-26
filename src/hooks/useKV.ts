import { useState, useEffect } from 'react';

/**
 * Custom hook to work with the Spark KV store
 * 
 * @param key The key to store the value under in the KV store
 * @param initialValue The default value to use if no value exists in the store
 * @returns [value, setValue, deleteValue] - Current value, setter function, and delete function
 */
export function useKV<T>(key: string, initialValue: T): [T, (value: T | ((prev: T) => T)) => void, () => Promise<void>] {
  const [value, setValue] = useState<T>(initialValue);
  const [isLoaded, setIsLoaded] = useState(false);

  // Load the initial value from KV store
  useEffect(() => {
    async function loadValue() {
      try {
        const storedValue = await window.spark.kv.get<T>(key);
        if (storedValue !== undefined) {
          setValue(storedValue);
        }
      } catch (error) {
        console.error(`Error loading value for key "${key}":`, error);
      } finally {
        setIsLoaded(true);
      }
    }
    
    loadValue();
  }, [key]);

  // Function to update value both in state and KV store
  const updateValue = async (newValue: T | ((prev: T) => T)) => {
    // If newValue is a function, call it with the current value to get the new value
    const updatedValue = newValue instanceof Function ? newValue(value) : newValue;
    
    // Update local state
    setValue(updatedValue);
    
    // Update KV store
    try {
      await window.spark.kv.set(key, updatedValue);
    } catch (error) {
      console.error(`Error saving value for key "${key}":`, error);
      // Optionally revert the local state if saving fails
    }
  };

  // Function to delete the value from KV store
  const deleteValue = async () => {
    try {
      await window.spark.kv.delete(key);
      setValue(initialValue);
    } catch (error) {
      console.error(`Error deleting value for key "${key}":`, error);
    }
  };

  return [value, updateValue, deleteValue];
}