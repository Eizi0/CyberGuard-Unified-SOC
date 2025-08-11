import React from 'react';
import { Box, Typography, Grid } from '@mui/material';
import {
  ComposableMap,
  Geographies,
  Geography,
  Marker
} from 'react-simple-maps';
import { scaleLinear } from 'd3-scale';
import { geoUrl } from '../../constants/mapData';

const ThreatMap = ({ data }) => {
  // Scale for marker size based on threat intensity
  const maxIntensity = Math.max(...data.map(d => d.intensity));
  const sizeScale = scaleLinear()
    .domain([0, maxIntensity])
    .range([4, 15]);

  return (
    <Box>
      <ComposableMap projection="geoMercator">
        <Geographies geography={geoUrl}>
          {({ geographies }) =>
            geographies.map(geo => (
              <Geography
                key={geo.rsmKey}
                geography={geo}
                fill="#EAEAEC"
                stroke="#D6D6DA"
              />
            ))
          }
        </Geographies>
        {data.map((threat, index) => (
          <Marker key={index} coordinates={[threat.longitude, threat.latitude]}>
            <circle
              r={sizeScale(threat.intensity)}
              fill="#F00"
              fillOpacity={0.6}
              stroke="#FFF"
              strokeWidth={1}
            />
          </Marker>
        ))}
      </ComposableMap>
      <Box mt={2}>
        <Typography variant="body2" color="textSecondary">
          Active Threats: {data.length}
        </Typography>
      </Box>
    </Box>
  );
};

export default ThreatMap;
