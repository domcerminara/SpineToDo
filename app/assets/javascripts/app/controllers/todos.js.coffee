$ = jQuery.sub()
Todo = App.Todo

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Todo.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('todos/new')

  back: ->
    @navigate '/todos'

  submit: (e) ->
    e.preventDefault()
    todo = Todo.fromForm(e.target).save()
    @navigate '/todos', todo.id if todo

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Todo.find(id)
    @render()
    
  render: ->
    @html @view('todos/edit')(@item)

  back: ->
    @navigate '/todos'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/todos'

class Show extends Spine.Controller
  events:
    'click [bata-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Todo.find(id)
    @render()

  render: ->
    @html @view('todos/show')(@item)

  edit: ->
    @navigate '/todos', @item.id, 'edit'

  back: ->
    @navigate '/todos'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Todo.bind 'refresh change', @render
    Todo.fetch()
    
  render: =>
    todos = Todo.all()
    @html @view('todos/index')(todos: todos)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/todos', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/todos', item.id
    
  new: ->
    @navigate '/todos/new'
    
class App.Todos extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/todos/new':      'new'
    '/todos/:id/edit': 'edit'
    '/todos/:id':      'show'
    '/todos':          'index'
    
  default: 'index'
  className: 'stack todos'