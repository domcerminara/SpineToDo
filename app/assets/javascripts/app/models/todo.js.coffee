class App.Todo extends Spine.Model
  @configure 'Todo', 'content', 'is_done'
  @extend Spine.Model.Ajax