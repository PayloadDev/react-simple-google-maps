module.exports = class InfoWindow extends React.Component

  @displayName = 'InfoWindow'

  @propTypes =
    closeOnClick:  React.PropTypes.bool
    googleMapsApi: React.PropTypes.object
    map:           React.PropTypes.object
    marker:        React.PropTypes.object
    position:      React.PropTypes.object
    setVisible:    React.PropTypes.func
    visible:       React.PropTypes.bool


  componentDidMount: ->
    infoWindowOptions = @buildInfoWindowOptions()
    infoWindow = new @props.googleMapsApi.InfoWindow infoWindowOptions

    @setState infoWindow: infoWindow, =>
      @open @props.map, @props.marker


  componentWillUnmount: ->
    @close()


  shouldComponentUpdate: (nextProps, nextState) ->
    return not _.isEqual nextProps, @props


  buildInfoWindowOptions: ->
    position: @props.position
    maxWidth: 500


  handleClick: (e) =>
    @props.setVisible false if @props.closeOnClick


  # expose some functionality directly from Google Maps API
  open: (map, marker) ->
    @state.infoWindow.setContent @refs.content
    @state.infoWindow.open map, marker


  close: ->
    @state.infoWindow.close()


  render: ->
    <div ref="content" onClick={@handleClick}>{@props.children}</div>
