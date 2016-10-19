shallowCompare = require 'react-addons-shallow-compare'

module.exports = class Polyline extends React.Component

  @displayName = 'Polyline'

  @propTypes =
    googleMapsApi: React.PropTypes.object
    icons:         React.PropTypes.array
    map:           React.PropTypes.object
    path:          React.PropTypes.array
    visible:       React.PropTypes.bool


  constructor: (props) ->
    @state =
      polyline: null


  componentDidMount: ->
    options = @buildPolylineOptions @props
    polyline = new @props.googleMapsApi.Polyline options

    @setState polyline: polyline


  componentWillUnmount: ->
    @props.googleMapsApi.event.clearInstanceListeners @state.polyline
    @state.polyline.setMap null


  componentWillReceiveProps: (nextProps) ->
    @state.polyline?.setOptions @buildPolylineOptions(nextProps)


  shouldComponentUpdate: (nextProps, nextState) ->
    shallowCompare @, nextProps, nextState


  buildPolylineOptions: (props) ->
    _.pick props, ['fillColor', 'geodesic', 'icons', 'map', 'path', 'strokeColor', 'strokeOpacity', 'visible']


  render: ->
    null
