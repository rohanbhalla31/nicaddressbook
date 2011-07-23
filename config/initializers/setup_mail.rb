ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "trainingnic11@gmail.com ",
  :password             => "training6",
  :authentication       => "plain",
  :enable_starttls_auto => true
}