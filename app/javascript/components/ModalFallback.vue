<template>
  <modal
      name="modal-fallback"
      width="700"
      height="auto"
    >
      <div class="mt-20 p-4">
        <div class="d-flex">
          <i class="icon__warn-big mx-auto mb-4"></i>
        </div>

        <p class="step2__text text-center mx-auto"
          v-html="modal.description">
        </p>

        <div class="d-sm-flex flex-sm-row-reverse justify-content-center">
          <a class="btn d-block d-sm-inline-block mb-15 blue-btn-active text-white" v-on:click="closeModalFallback">
            {{ modal.review_answers_btn }}
          </a>
          <a class="btn d-block d-sm-inline-block mb-15 mr-sm-15 blue-btn" href="/counselor-will-contact">
           {{ modal.cancel_btn }}
          </a>
        </div>

        <p class="subtext mb-20 mb-sm-30 small text-center"
          v-html="modal.small_note">
        </p>
      </div>
    </modal>
</template>

<script>

export default {
  name: 'ModalFallback',
  props: {
    modal: {
      type: Object,
      required: true
    }
  },
  methods: {
    closeModalFallback() {
      this.$modal.hide('modal-fallback');
    }
  }
}
</script>
