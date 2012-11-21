# The following fields are available for this model:
#  - id: the ide of this user
#  - name: the name of this user
#  - avatar: Name of the picture to be used as avatar
#
class Kanban.User extends Backbone.Model
  defaults:
    id: 0
    name: ""
    avatar: "Zombie.png"
