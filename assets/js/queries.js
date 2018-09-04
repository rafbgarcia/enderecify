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
  logradouros(busca: "av paulista sao paulo sp") {
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


export default queries
