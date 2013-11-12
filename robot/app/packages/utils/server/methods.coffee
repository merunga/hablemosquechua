Meteor.methods
  getENV: ->
    return process.env.ENV

  sendEmail: (to, subject, text, from=process.env.DEFAULT_EMAIL_FROM) ->
    this.unblock()
    to = process.env.TEST_EMAIL_TO if Utils.isDevelOrTest()
    subject = "[test] #{subject}" if Utils.isDevelOrTest()
    try
      mail = 
        to: to
        from: from
        replyTo: from
        subject: subject
        body: text
      Email.send mail
      mail.sentBy = this.userId
      mail.sentAt = Date.now()
      Notificaciones.insert mail
    catch e
      console.log "-*-*- [Error] Send email #{e}"
      console.log "to: #{to}"
      console.log "subject: #{subject}"
      console.log "text: #{text}"