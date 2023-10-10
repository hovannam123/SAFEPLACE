import { Controller } from "@hotwired/stimulus";
import { createPopup } from "@picmo/popup-picker";
import { RichText } from "../classes/RichText";

export default class extends Controller {
  static targets = ["form", "trixEditor", "pickerContainer"];

  initialize() {
    const buttonString = this.emojiButtonString();
    const emojiButton = this.emojiButtonTemplate(buttonString);
    let picker;
    let richText = new RichText(picker, emojiButton, this.formTarget);
    picker = createPopup(
      {
        rootElement: this.pickerContainerTarget
      },
      {
        triggerElement: emojiButton,
        referenceElement: emojiButton,
        position: "absolute",
        hideOnEmojiSelect: false,
        hideOnClickOutside: false
      }
    );

    picker.closeButton.setAttribute("type", "button");
    picker.closeButton.addEventListener("click", (event) => {
      picker.close();
    });

    picker.addEventListener("emoji:select", (event) => {
      this.trixEditorTarget.editor.insertString(event.emoji);
    });

    richText.setPicker(picker);
  }

  emojiButtonTemplate(buttonString) {
    const domParser = new DOMParser();
    const emojiButton = domParser
      .parseFromString(buttonString, "text/html")
      .querySelector("button");
    return emojiButton;
  }

  emojiButtonString() {
    const buttonString = `<button class="trix-button" id="emoji-picker-${this.index}" data-trix-action="popupPicker" tabindex="1">😀</button>`;
    return buttonString;
  }
}
