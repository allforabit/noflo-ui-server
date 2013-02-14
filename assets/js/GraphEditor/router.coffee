#= require ../vendor/jquery-ui
#= require ../vendor/jquery.ui.touch-punch
#= require ../vendor/jsplumb
#= require views

class window.noflo.GraphEditor.Router extends Backbone.Router
  graphs: null
  root: null

  routes:
    'graph/:network': 'graph'

  initialize: (options) ->
    @graphs = options.graphs
    @root = options.root
    jsPlumb.setRenderMode jsPlumb.CANVAS

  graph: (id) ->
    graph = @graphs.get id
    return @navigate '', true unless graph

    view = new window.noflo.GraphEditor.views.Graph
      model: graph
      graphs: @graphs
      router: @
    @root.html view.render().el

    # Fetch full graph information and activate view
    done = _.after 3, -> view.initializeEditor()
    graph.get('nodes').fetch success: done
    graph.get('edges').fetch success: done
    graph.fetch success: done