import queries from "./queries"

$('.js_send_request').click(function () {
  const key = $(this).data('code')
  const query = queries[key] || ace.edit($('#graphql-editor')[0]).getValue()
  ace.edit($('#graphql-editor')[0]).setValue(query, -1)
  const t0 = performance.now()

  fetch('/', {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({query})
  })
  .then(async (resp) => {
    const time = Math.round(performance.now() - t0)
    const data = await resp.json()
    let contentLength = JSON.stringify(data).length
    contentLength = contentLength < 1024 ? `${contentLength} bytes` : `${Math.round(contentLength / 1024 * 10) / 10} KB`
    const responseEl = $('#response')
    responseEl.removeClass('d-none').html(`Resposta: enviados <code>${contentLength}</code> em <code>${time}ms</code>`)

    const editor = ace.edit($('#result')[0])
    editor.session.setMode("ace/mode/json")
    editor.setValue(JSON.stringify(data, null, '\t'), -1)
    editor.gotoLine(0, 0)
  })
})

$('.ace-editor.graphql').each((_, el) => {
  var editor = ace.edit(el)
  editor.setTheme("ace/theme/cobalt")
  editor.setOptions({
    tabSize: 2,
    showFoldWidgets: false,
  })
  editor.container.classList.add("transparent-editor")
  editor.session.setOptions({
    mode: "ace/mode/graphqlschema",
    useSoftTabs: true,
  });
})

const resultEditor = ace.edit($('#result')[0])
resultEditor.setTheme("ace/theme/cobalt")
resultEditor.setOptions({
  tabSize: 2,
  readOnly: true,
  showFoldWidgets: false,
})
resultEditor.container.classList.add("transparent-editor")
resultEditor.session.setOptions({
  mode: "ace/mode/javascript",
  useSoftTabs: true,
});
