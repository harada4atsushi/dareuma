/*dareuma = {
  submit: function(form, method) {
    //if method == "delete" || method == "put" || method == "create"
    $('<input />').attr('type', 'hidden')
      .attr('name', "_method")
      .attr('value', method)
      .appendTo($(form));
    $(form).submit();
    return false;
  },
}*/

/*
@kobako = {}

###*
 * formをsubmitする
 * @param {url} form.actionにセットするURL
 * @param {method} form.methodにセットするmethod get, post, delete, put ...
 * @param {form} formの指定 引き数の方によって処理が分岐する
 *     文字列 => 対象formのid
 *     数値 => #contentsの子要素のform[]のindex
 *     element => formのelement
 * @return false
###
@kobako.submit = (url, method, form) ->
  switch typeof form
    when "string"
      $form = $("##{form}")
    when "number"
      $form = $("#contents form")[form]
    when "object"
      $form = $(form)
    else
      return false

  if method == "delete" || method == "put" || method == "create"
    $('<input />').attr('type', 'hidden')
      .attr('name', "_method")
      .attr('value', method)
      .appendTo($form)
  else if method
    $form.method = method if method
  $form.action = url if url
  $form.submit()
  false

###*
 * formをdeleteメソッドでsubmitする
 * @param {url} form.actionにセットするURL
 * @param {form} formの指定 引き数の方によって処理が分岐する
 * @return false
###
@kobako.delete = (url, form = 0) ->
  kobako.submit(url, "delete", form)

###*
 * formをpostメソッドでsubmitする
 * @param {url} form.actionにセットするURL
 * @param {form} formの指定 引き数の方によって処理が分岐する
 * @return false
###
@kobako.post = (url, form = 0) ->
  kobako.submit(url, "post", form)

###*
 * 別ウィンドウを起動する
 * @param {url} 起動するURL
 * @param {hegith} 高さ
 * @param {width} 幅
###
@kobako.open = (url, height = 550, width = 450) ->
  window.open(url,"new","resizable=1,scrollbars=1,status=1,height=" + height + ",width=" + width);

$ ->
  $('.datepicker').datepicker()

  # ブラウザバック時のsubmitボタンの制御
  $('input[type=submit]', this).attr('disabled', false)
  $('form').submit ->
    $('input[type=submit]', this).attr('disabled', true)

*/