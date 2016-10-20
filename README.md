# react-simple-google-maps
Simple components for rendering Google Maps via the Google Maps JavaScript API

## Installation

`npm install react react-addons-shallow-compare react-simple-google-maps`

## Usage

Ensure the Google Maps JS API script is already loaded. `react-simple-google-maps` will use a global named `google.maps`.

To create a new map, just render a `<Map>` component. Markers and Polylines are children of the Map, and an InfoWindow can be a child of a Marker. An InfoWindow's children will be rendered into the InfoWindow when it is displayed.

Coordinates are passed using the native Google Maps coordinates or bounds objects.

```javascript
bounds = new google.maps.LatLngBounds();
position = new google.map.LatLng(65, -100);
bounds.extend(position);
position = new google.map.LatLng(40, -125);
bounds.extend(position);

markerPosition = new google.map.LatLng(50, -115);

<Map
  bounds={bounds}
  panControlOptions={position: google.maps.ControlPosition.LEFT_BOTTOM}
  ref="map"
  scrollwheel={true}
  streetViewControl={false}
  style={height: 500}
  zoomControlOptions={position: google.maps.ControlPosition.LEFT_BOTTOM} >
  <Marker
    position={markerPosition}
    title='Start'
    zIndex=1>
    <InfoWindow>
      <h1>I am a marker!</h1>
    </InfoWindow>
  </Marker>
</Map>
```
