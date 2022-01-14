<template>
  <div>
    <h3 class="text-center mt-2 mb-15">
      {{ surveyStep.title }}
    </h3>

    <div class="d-flex mb-30">
      <p class="steps__description mx-auto mb-0 text-justify"
        v-html="surveyStep.description">
      </p>
    </div>

    <div
      v-for="(qstionGrp, index) in questionGroups"
      v-bind:key="`qstionGrp-${index}`"
    >
      <div class="steps__general text-center py-2 mb-30"
        v-if="qstionGrp.header">
        <b>{{qstionGrp.header}}</b>
      </div>
      <div class="options"
        v-for="(question, i) in qstionGrp.questions"
        v-bind:key="`question${question.id}`">

        <div class="steps__row">
          <div class="steps__row-main">
            <div class="mr-auto steps__text-question"
              v-html="question.question">
            </div>

            <i
              class="icon__i mr-30 mr-sm-60"
            >
            </i>

            <label class="controls controls__checkbox controls__checkbox_blue"
              v-if="question.question_type == 'checkbox' || question.question_type == 'checkbox agreement'">

              <input
                v-model="answers[i].answer"
                type="checkbox"
                true-value="yes"
                false-value="no"
              >
              <span class="checkmark">
              </span>
            </label>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'SurveyStep',
  props: {
    surveyStep: {
      type: Object,
      required: true
    },
    consentStep: {
      type: Number,
      required: true
    },
    answers: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      answers: []
    }
  },
  computed: {
    questionGroups() {
      return this.surveyStep.groups;
    }
  },
  methods: {
  },
  watch: {
    surveyStep(value) {
      this.$emit('fillAnswers')
    }
  },
  created() {
    this.$emit('fillAnswers')
  }
}
</script>
