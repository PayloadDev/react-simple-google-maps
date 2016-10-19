_ =
  isEqual: require 'lodash/lang/isEqual'
  pick:    require 'lodash/object/pick'

module.exports = class GoogleMap extends React.Component

  @displayName = 'GoogleMap'

  @propTypes =
    bounds:            React.PropTypes.object
    center:            React.PropTypes.object
    googleMapsApi:     React.PropTypes.object
    scrollwheel:       React.PropTypes.bool
    streetViewControl: React.PropTypes.bool
    style:             React.PropTypes.object
    zoom:              React.PropTypes.number


  constructor: (props) ->
    # @TODO: address Maps API memory leak: https://code.google.com/p/gmaps-api-issues/issues/detail?id=3803#c32
    @state =
      map: null


  componentDidMount: ->
    mapOptions = @buildMapOptions @props
    map = new @props.googleMapsApi.Map @refs.map, mapOptions

    map.fitBounds @props.bounds if @props.bounds?
    @bindEvents map

    @setState
      map: map


  componentDidUpdate: (prevProps, prevState) ->
    # trigger resize event in case we've re-rendered the map
    @props.googleMapsApi.event.trigger @state.map, 'resize'

    if @props.allowReCenter and not _.isEqual @props.center, prevProps.center
      @setCenter @props.center

    @fitBounds @props.bounds unless _.isEqual prevProps.bounds, @props.bounds

    @setZoom @props.zoom unless prevProps.zoom is @props.zoom


  bindEvents: (map) ->
    for key,func of _.pick @props, ['onClick', 'onDblClick', 'onRightClick', 'onMouseOver', 'onMouseOut', 'onBoundsChanged', 'onZoomChanged']
      # convert property name to event name
      eventName = key[2..].toLowerCase().replace 'changed', '_changed' # for some reason change events are snake cased
      @props.googleMapsApi.event.addListener map, eventName, func


  buildMapOptions: (props) ->
    _.pick props, ['center', 'zoom', 'scrollwheel', 'streetViewControl', 'panControlOptions', 'zoomControlOptions', 'mapTypeId', 'mapTypeControlOptions']


  # expose some functionality directly from Google Maps API
  fitBounds: (bounds) ->
    @state.map?.fitBounds bounds if bounds?


  setZoom: (zoom) ->
    @state.map?.setZoom zoom if zoom?


  setCenter: (center) ->
    @state.map?.panTo center if center?


  panToBounds: (bounds) ->
    @state.map?.panToBounds bounds


  getBounds: ->
    @state.map?.getBounds()


  getZoom: ->
    @state.map?.getZoom()


  render: ->
    if @state.map?
      children = React.Children.map @props.children, (child) =>
        if child? then React.cloneElement child,
          map:           @state.map
          googleMapsApi: @props.googleMapsApi

    <div style={_.pick @props.style, 'height'} className='google-map'>
      <div ref="map" style={@props.style} />
      {children}
    </div>
