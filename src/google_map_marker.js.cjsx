shallowCompare = require 'react-addons-shallow-compare'

module.exports = class Marker extends React.Component

  @displayName = 'Marker'

  @propTypes =
    clickable:     React.PropTypes.bool
    googleMapsApi: React.PropTypes.object
    iconName:      React.PropTypes.string
    map:           React.PropTypes.object
    opacity:       React.PropTypes.number
    position:      React.PropTypes.object
    title:         React.PropTypes.string
    visible:       React.PropTypes.bool

  @defaultProps =
    visible:  true
    iconName: 'default'


  constructor: (props) ->
    @state =
      marker:   null
      showInfo: false


  componentDidMount: ->
    markerOptions = @buildMarkerOptions @props
    marker = new @props.googleMapsApi.Marker markerOptions

    @setState marker: marker

    @bindChildren marker

    @bindEvents marker

    marker.setMap @props.map


  componentWillUnmount: ->
    @props.googleMapsApi.event.clearInstanceListeners @state.marker
    @state.marker.setMap null
    @markerUnmounted = true


  componentWillReceiveProps: (nextProps) ->
    @state.marker.setOptions @buildMarkerOptions(nextProps)


  componentDidUpdate: (prevProps, prevState) ->
    @state.marker.setOptions @buildMarkerOptions(@props)


  shouldComponentUpdate: (nextProps, nextState) ->
    if nextProps.position.equals @props.position
      shallowCompare @, nextProps, nextState
    else
      true


  buildMarkerOptions: (props) ->
    options = _.pick props, ['position', 'title', 'visible', 'opacity', 'zIndex', 'draggable']
    options.clickable = props.onClick? or !!React.Children.count(props.children)
    options.icon =
      url:        props.iconName
      scaledSize: width: 32, height: 32
    options


  bindEvents: (marker) ->
    for key,func of _.pick @props, ['onClick', 'onDblClick', 'onRightClick', 'onMouseOver', 'onMouseOut', 'onDragEnd']
      # convert property name to event name
      eventName = key[2..].toLowerCase()
      @props.googleMapsApi.event.addListener marker, eventName, func


  bindChildren: (marker) ->
    return unless marker? and React.Children.count(@props.children)

    @props.googleMapsApi.event.addListener marker, 'click', =>
      # trigger a click event on the map below to close any other info windows
      @props.googleMapsApi.event.trigger @props.map, 'click'
      # open the info window
      @setVisible true

      # close the window on any other click
      offListener = @props.googleMapsApi.event.addListener @props.map, 'click', =>
        @setVisible false
        @props.googleMapsApi.event.removeListener offListener


  setVisible: (visible=false) =>
    @setState showInfo: visible unless @markerUnmounted


  render: ->
    if @state.marker? and @state.showInfo and React.Children.count(@props.children)
      child = React.Children.only @props.children
      if child? then child = React.cloneElement child,
        googleMapsApi: @props.googleMapsApi
        visible:       @state.showInfo
        map:           @props.map
        marker:        @state.marker
        setVisible:    @setVisible

    return null unless child?

    <div>
      {child}
    </div>
