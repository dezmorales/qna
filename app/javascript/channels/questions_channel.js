import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
    consumer.subscriptions.create("QuestionsChannel", {
        connected() {
            this.perform('follow')
        },
        received(data) {
            $('.questions').append(data)
        }
    })
})
