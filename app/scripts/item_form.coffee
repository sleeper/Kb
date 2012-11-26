class ItemForm
    template = '<form class="form-horizontal">' +
    '<legend> New Item </legend>' +
    '<div class="control-group">' +
    '<label class="control-label" for="inputTitle">Title</label>' +
    '<div class="controls"><input type="text" id="inputTile" placeholder="Title" autofocus></div>' +
    '</div>' +
    '<div class="control-group">' +
    '<label class="control-label" for="inputProject">Project</label>' +
    '<div class="controls"><input type="text" id="inputProject" placeholder="Project"></div>' +
    '</div>' +
    '<div class="control-group">' +
    '<label class="control-label" for="inputPriority">Priority</label>' +
    '<div class="controls"><input type="number" id="inputPriority" placeholder="100"></div>' +
    '</div>' +
    '<div class="control-group">' +
    '<label class="control-label" for="inputSwimlane">Swimlane</label>' +
    '<div class="controls"><input type="text" id="inputSwimlane" placeholder="Swimlane"></div>' +
    '</div>' +
    '<div class="control-group">' +
    '<label class="control-label" for="inputPOC">POC</label>' +
    '<div class="controls"><input type="text" id="inputPOC" placeholder="POC"></div>' +
    '</div>' +
    '<div class="control-group">' +
    '<label class="control-label" for="inputComment">Comment</label>' +
    '<div class="controls"><input type="textarea" id="inputComment" placeholder="Comment"></div>' +
    '</div>' +
    '<div class="form-actions">' +
    '<button type="submit" class="submit btn btn-primary">Save changes</button>' +
    '<button type="button" class="cancel btn">Cancel</button>' +
    '</div>' +
    '</form>'

    destroy: ()->
        @so.overlay.remove()
        @so.dialog.remove()

    constructor: (el)->
        @so = new SimpleOverlay $('body')
        @so.overlay.on 'click', ()=>
            @destroy()
        @so.dialog.append template
        @so.hide()
        @submit = $('.submit', @so.dialog)
        @cancel = $('.cancel', @so.dialog)
        @cancel.on 'click', ()=> @destroy()

    show: ()->
        @so.show()

    on_cancel: (cb) -> @cancel.on 'click', ()=>
        cb()
        @destroy()

    on_submit: (cb)-> @submit.on 'click', ()=>
        cb()
        @destroy()

window.ItemForm = ItemForm