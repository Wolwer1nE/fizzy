import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  #hiddenField

  static targets = [ "label", "item", "hiddenFieldTemplate" ]
  static values = {
    selectPropertyName: { type: String, default: "aria-checked" },
    defaultValue: String
  }

  connect() {
    this.labelTarget.textContent = this.#selectedLabel
  }

  change(event) {
    const item = event.target.closest("[role='checkbox']")
    if (item) {
      this.#selectedItem = item
    }
  }

  get #selectedLabel() {
    return this.#selectedItem?.dataset?.comboboxLabel || ""
  }

  get #selectedItem() {
    return this.itemTargets.find(item => item.getAttribute(this.selectPropertyNameValue) === "true")
  }

  set #selectedItem(item) {
    this.#clearSelection()
    item.setAttribute(this.selectPropertyNameValue, "true")
    this.labelTarget.textContent = this.#selectedLabel
    this.hiddenField.value = item.dataset.comboboxValue
  }

  #clearSelection() {
    this.itemTargets.forEach(target => {
      target.setAttribute(this.selectPropertyNameValue, "false")
    })
  }

  get hiddenField() {
    if (!this.#hiddenField) {
      this.#hiddenField = this.#buildHiddenField()
    }
    return this.#hiddenField
  }

  #buildHiddenField() {
    const [field] = this.hiddenFieldTemplateTarget.content.cloneNode(true).children
    this.element.appendChild(field)
    return field
  }
}
