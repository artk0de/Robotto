## The bot used for CIPR 2016 IT conference in Innopolis, Russia

require "rbender"
require_relative 'ciprschedule'
# token = '213106430:AAHRqB1O4eZLeMMDbNLyVjc0_ZtGziDopV8'

params({mongo: 'mongo://localhost',
            bot_name: "CiprBot",
            token: token})

CiprSchedule.driver = RBender::MongoClient.client
CiprSchedule.instance.load_schedule


state :start do
  text do
    case message.text
      when '/start'
        admin_list = [80877405]

        if admin_list.include? session[:user][:chat_id]
          session[:is_admin] = true
        else
          session[:is_admin] = false
        end
        switch(:main)
    end
  end
end

state :main do
  before do
    unless session[:user][:first_name].empty?
      user_name = session[:user][:first_name]
    else
      user_name = "дорогой гость"
    end
    greeting_text = ""
    greeting_text << "Добро пожаловать на <b>ЦИПР</b>, #{user_name}! \n"
    greeting_text << "Этот бот поможет Вам получать актуальные сведения о конференции, "
    greeting_text << "просматривать расписания, узнавать о предстоящих мероприятиях. \n"

    send_message text: greeting_text,
                 reply_markup: inline_markup(:kb_main),
                 parse_mode: 'HTML'

  end

  keyboard_inline :kb_main do

    button :btn_schedule, "Расписание" do
      edit_message_text text: get_schedule(@helper.current_day),
                        reply_markup: inline_markup(:kb_schedule),
                        parse_mode: 'HTML'
      answer_callback_query text: "Актуальное расписание"
    end

    button :btn_what_is_next, "Ближайшие мероприятия" do
      edit_message_text text: get_next,
                        reply_markup: inline_markup(:kb_main),
                        parse_mode: 'HTML'
      answer_callback_query text: "Данные обновлены"
    end

    button :btn_about, "О боте" do
      text = "Бот сделан командой <b>AnyBots</b>\n"
      text << "По вопросам сотрудничества обращайтесь к @Spiritized"
      edit_message_text text: text,
                        reply_markup: inline_markup(:kb_main),
                        parse_mode: 'HTML'
      answer_callback_query text: "Информация о боте"
    end

    add_line :btn_what_is_next
    add_line :btn_schedule
    add_line :btn_about
  end

  keyboard_inline :kb_schedule do

    (1..4).each do |i| # generate buttons
      button "btn_day_#{i}", "День #{i}" do
        edit_message_text text: get_schedule(i),
                          reply_markup: inline_markup(:kb_schedule),
                          parse_mode: 'HTML'
        answer_callback_query text: "День #{i}"
      end
    end # end

    button :btn_back, "Главное меню" do
      edit_message_text text: get_next,
                        reply_markup: inline_markup(:kb_main),
                        parse_mode: 'HTML'
    end

    add_line 'btn_day_1',
             'btn_day_2',
             'btn_day_3',
             'btn_day_4'
    add_line :btn_back

  end

  keyboard_inline :kb_additional do
    button :btn_show_menu, "Показать меню" do
      hide_inline
      send_message text: get_next,
                   reply_markup: inline_markup(:kb_main),
                   parse_mode: 'HTML'

      answer_callback_query text: "Главное меню"
    end

    add_line :btn_show_menu
  end
  helpers do
    @helper = CiprSchedule.instance

    def get_schedule(day_num)
      day_num = 1 if day_num < 1 or day_num > 4

      schedule = @helper.schedule(day_num)
      schedule_text = "<i>#{day_num + 6} июня</i>\n"
      schedule_text << "<b>День #{day_num}:</b>\n\n"
      schedule.each do |event|
        schedule_text << event_line(event)
      end
      schedule_text
    end

    def get_next
      text = ""
      current = @helper.events_current
      text << "<b>Текущие мероприятия:</b> ⌛️\n\n" unless current.empty?
      current.each do |event|
        text << event_line(event)
      end

      current_day = @helper.current_day
      events_next = @helper.events_next (current_day)


      unless events_next.empty?
        unless text.empty?
          text << "\n\n"
        end
        text << "<b>Ближайшие мероприятия</b> ⏳\n\n"
        events_next.each do |event|
          text << event_line(event)
        end
      else
        if current_day < 4
          text << "<b>Мероприятия на завтра:</b> ⏰\n\n"
          events_next = @helper.events_next (current_day + 1)
          events_next.each do |event|
            text << event_line(event)
          end
        else
          if current.empty?
            text << "Форум завершен! Спасибо за посещение форума, будем рады Вас видеть в следующем году!"
          end
        end
      end

      text
    end

    def event_line(event)
      line = ""
      hour = event['time_start'].hour
      min = event['time_start'].min
      min = "00" if min.zero?
      line << "<b>#{hour}:#{min}</b>"
      line << " - #{event['event']}"
      line << " - <i>#{event['place']}</i>\n"

      line
    end
  end

  text do
    if session[:is_admin] and (not message.text == '/start')
      user_list = BoteeBot::SessionManager.chatid_list
      user_list.each do |chat_id|
        begin
          send_message text: message.text,
                       chat_id: chat_id,
                       reply_markup: inline_markup(:kb_additional)
        rescue
        end
      end
    end
  end
end

run!