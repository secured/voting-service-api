import nodemailer from 'nodemailer'
import { pugEngine } from 'nodemailer-pug-engine'

export default {
  transport: null,
  async init () {
    let config = {
      host: process.env.MAIL_HOST,
      port: process.env.MAIL_PORT,
      pool: process.env.MAIL_USE_POOL === '1',
      secure: process.env.MAIL_USE_TLS === '1'
    }

    // Add auth if needed.
    if (process.env.MAIL_USE_AUTH === '1') {
      config = Object.assign(config, {
        auth: {
          user: process.env.MAIL_AUTH_USER,
          pass: process.env.MAIL_AUTH_PASS
        }
      })
    }

    this.transport = nodemailer.createTransport(config)
    await this.transport.verify(function (error, success) {
      if (error) {
        console.error('ERROR: Server is unable to send mails. Error message: ' + error.message)
      } else {
        console.log('INFO: Server is ready to send mails.')
      }
    })
    this.transport.use('compile', pugEngine({
      templateDir: __dirname + '/emails',
      pretty: true
    }))
  },
  async sendMail (config) {
    if (!this.transport) {
      await this.init()
    }
    await this.transport.sendMail(config, function (error, info) {
      if (error) {
        console.error('ERROR: Server is unable to send mails. Error message: ' + error.message)
      }
      if (info && process.env.ENABLE_DEBUG === '1') {
        console.log(info)
      }
    })
  }
}
