$('document').ready ->
  $('#js-auction-btn').on 'click', ->
    dateStart = $('#auction_open_at_1i').val() + '/'
    dateStart+= $('#auction_open_at_2i').val() + '/'
    dateStart+= $('#auction_open_at_3i').val() + ' '
    dateStart+= $('#auction_open_at_4i').val() + ':'
    dateStart+= $('#auction_open_at_5i').val()
    dateStartValue = Date.parse(dateStart)
    nowValue = Date.parse(new Date())
    if nowValue >= dateStartValue
      msg = "開始時刻が現在以前になっています。\n" +
          "この場合、オークションは登録後即時開催され、データの編集ができなくなります。\n" +
          "このまま登録しても本当によろしいですか ?"
      if !window.confirm(msg)
        return false
  return
