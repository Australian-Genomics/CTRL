<template>
  <div class="d-flex mt-3 mt-sm-0 text-capitalize">
  <span v-for="(option, oi) in question.options">
    <label>
      <label class="controls controls__radio controls__radio_blue ml-sm-15">
        <input type="radio"
               v-bind:value="option.value"
               v-model="modalVal"
        >
        <span class="checkmark"></span>
        <span class="label-text ml-1 mr-1">{{ option.value }}</span>
      </label>
    </label>
  </span>
  </div>
</template>
<script>
export default {
  name: 'RadioButton',
  props: {
    question: {
      type: Object,
      required: true
    },
    modalVal: {
      type: String,
      required: true
    }
  }
}
</script>
