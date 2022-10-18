<template>
  <modal
      name="modal-server-error"
      width="700"
      height="auto"
  >
    <div class="mt-20 p-4">
      <div class="d-flex">
        <i class="icon__warn-big mx-auto mb-4"></i>
      </div>

      <div class="step2__text text-center mx-auto">
        <h3>{{modal.something_went_wrong}}</h3>
        <br/>
        <p>{{modal.responses_not_saved}}</p>
      </div>

      <div class="d-sm-flex flex-sm-row-reverse justify-content-center">
        <a class="btn d-block d-sm-inline-block mb-15 blue-btn-active text-white" v-on:click="closeModalServerError">
          {{ modal.close }}
        </a>
      </div>
    </div>
  </modal>
</template>

<script>

export default {
  name: 'ModalServerError',
  props: {
    modal: {
      type: Object,
      required: true
    }
  },
  methods: {
    closeModalServerError() {
      this.$modal.hide('modal-server-error');
    }
  }
}
</script>
