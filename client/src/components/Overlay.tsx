import React, { useEffect, useState } from "react";
import { DataSchema } from "../types/types";

interface OverlayProps {
  overlayVisible: boolean;
  selectedCoords: [number, number];
}

const Overlay: React.FC<OverlayProps> = ({
  overlayVisible,
  selectedCoords,
}) => {
  const [coordData, setCoordData] = useState<DataSchema>();

  useEffect(() => {
    async function fetchCoordData(coords: [number, number]) {
      const response = await fetch(
        `http://localhost:5000/latlon/${coords[1]}_${coords[0]}`
      );
      setCoordData(await response.json());
    }
    fetchCoordData(selectedCoords);
  }, [selectedCoords]);

  return (
    <div
      style={{
        visibility: overlayVisible ? "visible" : "hidden",
        width: "300px",
        position: "absolute",
        top: 2,
        right: 2,
        backgroundColor: "white",
      }}
    >
      <p>{`${selectedCoords[0]}, ${selectedCoords[1]}`}</p>
    </div>
  );
};

export default Overlay;
