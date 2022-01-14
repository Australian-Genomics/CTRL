<template>
  <div class="options">
    <div class="steps__row">
      <div class="steps__row-main">
        <div class="mr-auto steps__text-question"
          v-html="question.question">
        </div>

        <i class="icon__i mr-30 mr-sm-60">
        </i>

        <label class="controls controls__checkbox controls__checkbox_blue"
          v-if="question.question_type == 'checkbox' || question.question_type == 'checkbox agreement'">

          <input
            v-model="answer[i].answer"
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
</template>

<script>
export default {
  name: 'SurveyQuestion',
  props: {
    question: {
      type: Object,
      required: true
    },
    answer: {
      type: Object,
      required: true
    }
  }
}
</script>
