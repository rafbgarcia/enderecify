import css from "../css/app.css"

import "phoenix_html"
import "bootstrap"
import 'regenerator-runtime/runtime';

import "./font-awesome"
import "./theme"

const queries = {
  regioes: `{
  regioes {
    sigla
    nome
  }
}
`,
  estados: `{
  estados {
    nome
    sigla
  }
}`,
  localidades: `{
  cidades: localidades(siglaEstado: "SP") {
    id
    nome
  }
}`,
  bairros: `{
  bairros(localidadeId: 9668) {
    id
    nome
    cidade: localidade { nome }
  }
}`,
  logradourosBusca: `{
  logradouros(busca: "rua sen salgado filho rs") {
    linha1
    cidade: localidade { nome }
  }
}`,
  logradourosBuscaCidade: `{
  logradouros(busca: "av pauli", localidadeId: 9668) {
    linha1
    saoPaulo: localidade { nome }
  }
}`,
  logradourosCep: `{
  logradouros(cep: "85851-290") {
    nome abbr
    bairro { nome }
    cep: formattedCep
    normalCep: cep
    cidade: localidade { nome }
    estado {
      nome
      regiao { nome }
    }
  }
}`
}

$('.js_send_request').click(function () {
  const key = $(this).data('code')
  const query = queries[key] || ace.edit($('#graphql-editor')[0]).getValue()
  ace.edit($('#graphql-editor')[0]).setValue(query, -1)
  const t0 = performance.now()

  fetch('/api', {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({query})
  })
  .then(async (resp) => {
    const time = Math.round(performance.now() - t0)
    const contentLength = resp.headers.get('content-length')
    const data = await resp.json()
    const responseEl = $('#response')
    responseEl.removeClass('d-none').html(`Resposta: <code>${contentLength} bytes</code> em <code>${time}ms</code>`)

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
