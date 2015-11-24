package todomvc.view;

import Doom.*;
import doom.PropertiesComponent;
import js.html.KeyboardEvent;
import todomvc.data.TodoItem;
using thx.Strings;

class Item extends PropertiesComponent<ItemProperties, ItemState> {
  override function render()
    return LI([
        "class" => [
          "completed" => state.item.completed,
          "editing"   => state.editing,
        ],
        "dblclick" => handleDblClick
      ], [
      DIV(["class" => "view"], [
        INPUT([
          "class"   => "toggle",
          "type"    => "checkbox",
          "checked" => state.item.completed,
          "change"  => prop.toggle
        ]),
        LABEL(state.item.text),
        BUTTON([
          "class" => "destroy",
          "click" => prop.remove
        ])
      ]),
      INPUT([
        "class" => "edit",
        "value" => state.item.text,
        "blur"  => handleBlur,
        "keyup" => handleKeydown,
      ])
    ]);

  function handleDblClick() {
    state.editing = true;
    update(state);
    getInput().select();
  }

  function handleBlur() {
    if(!state.editing) return;
    state.editing = false;
    var value = getInputValueAndTrim();
    if(value.isEmpty()) {
      prop.remove();
    } else {
      prop.updateText(value);
    }
  }

  function handleKeydown(e : KeyboardEvent) {
    if(e.which != dots.Keys.ENTER)
      return;
    handleBlur();
  }

  function getInput() : js.html.InputElement
    return cast element.querySelector("input.edit");

  function getInputValueAndTrim() {
    var input = getInput();
    return input.value = input.value.trim();
  }
}

typedef ItemProperties = {
  public function remove() : Void;
  public function toggle() : Void;
  public function updateText(text : String) : Void;
}

typedef ItemState = {
  item : TodoItem,
  editing : Bool
}