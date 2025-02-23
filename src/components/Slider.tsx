import React from 'react';
import * as SliderPrimitive from '@radix-ui/react-slider';

interface SliderProps {
  min: number;
  max: number;
  step: number;
  value: [number, number];
  onChange: (value: [number, number]) => void;
}

export function Slider({ min, max, step, value, onChange }: SliderProps) {
  return (
    <div className="relative flex items-center w-full h-5">
      <SliderPrimitive.Root
        className="relative flex items-center w-full h-5"
        value={value}
        onValueChange={onChange as any}
        min={min}
        max={max}
        step={step}
      >
        <SliderPrimitive.Track className="relative w-full h-2 bg-gray-200 rounded-full">
          <SliderPrimitive.Range className="absolute h-full bg-blue-500 rounded-full" />
        </SliderPrimitive.Track>
        <SliderPrimitive.Thumb className="block w-5 h-5 bg-white border-2 border-blue-500 rounded-full shadow focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2" />
        <SliderPrimitive.Thumb className="block w-5 h-5 bg-white border-2 border-blue-500 rounded-full shadow focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2" />
      </SliderPrimitive.Root>
      <div className="absolute w-full flex justify-between text-xs text-gray-500 mt-8">
        <span>{value[0].toLocaleString()}</span>
        <span>{value[1].toLocaleString()}</span>
      </div>
    </div>
  );
}