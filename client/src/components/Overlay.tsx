import React, { useEffect, useState } from "react";
import { DataSchema } from "../types/types";

interface OverlayProps {
  overlayVisible: boolean;
  selectedCoordData: DataSchema;
}

const Overlay: React.FC<OverlayProps> = ({
  overlayVisible,
  selectedCoordData,
}) => {
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
      <p>
        {selectedCoordData
          ? `${selectedCoordData.lon}, ${selectedCoordData.lat}`
          : ""}
      </p>
      <div
        style={{
          display: "flex",
          flexDirection: "row",
          //   backgroundColor: "red",
        }}
      >
        <div style={{ width: "50%", textAlign: "center" }}>
          <p style={{ fontWeight: 600, fontSize: 20 }}>Slope angle</p>
          <p style={{ fontSize: 28 }}>
            {selectedCoordData
              ? (selectedCoordData.slope / 100).toString() + "°"
              : ""}
          </p>
        </div>
        <div style={{ width: "50%", textAlign: "center" }}>
          <p style={{ fontWeight: 600, fontSize: 20 }}>Aspect</p>
          <p style={{ fontSize: 28 }}>
            {selectedCoordData
              ? (selectedCoordData.aspect / 100).toString() + "°"
              : ""}
          </p>
        </div>
      </div>
      <div style={{ display: "flex", flexDirection: "row" }}>
        <div style={{ width: "50%", textAlign: "center" }}>
          <p style={{ fontWeight: 600, fontSize: 20 }}>
            Distance to Geological Boundary
          </p>
          <p style={{ fontSize: 28 }}>
            {selectedCoordData
              ? selectedCoordData.distGeo.toString() + "km"
              : ""}
          </p>
        </div>
        <div style={{ width: "50%", textAlign: "center" }}>
          <p style={{ fontWeight: 600, fontSize: 20 }}>Aspect</p>
          <p style={{ fontSize: 28 }}>
            {selectedCoordData
              ? (selectedCoordData.aspect / 100).toString() + "°"
              : ""}
          </p>
        </div>
      </div>
    </div>
  );
};

export default Overlay;
