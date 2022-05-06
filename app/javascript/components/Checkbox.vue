<template>
  <div class="checkbox-opts">
  <label class="controls controls__checkbox controls__checkbox_blue ml-sm-15">
    <input
        v-model="modalVal"
        type="checkbox"
        true-value="yes"
        false-value="no"
    >
    <span class="checkmark"></span>
  </label>
  </div>
</template>

<script>
  export default {
    name: 'Checkbox',
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
