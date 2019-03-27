const _ = require('lodash')
const uuid = require('uuid/v1')
const data = require('./parseWeeks')

const tags = _.uniq(data.map(e => e.tags).flat())

const wordIdMap = {}
data.forEach(e => {
    let id = e.wordText
    let count = 0
    while (!!wordIdMap[id]) {
        id = `${e.wordText}-${++count}`
    }
    e.id = id
})

let groups = tags.sort().map(t => {
    let displayName = t
    if (displayName.indexOf('DAY') === -1) {
        displayName = `Whole ${t}`
    }
    const group = {
        id: t,
        name: t,
        displayName,
        children: data.filter(d => d.tags.includes(t)).map(d => d.id)
    }
    return group
})
// console.log(groups.map(e => e.id));

const groupNamesInOrder = [
    'WEEK1-DAY1',
    'WEEK1-DAY2',
    'WEEK1-DAY3',
    'WEEK1-DAY4',
    'WEEK1-DAY5',
    'WEEK1',
    'WEEK2-DAY1',
    'WEEK2-DAY2',
    'WEEK2-DAY3',
    'WEEK2-DAY4',
    'WEEK2-DAY5',
    'WEEK2',
    'WEEK3-DAY1',
    'WEEK3-DAY2',
    'WEEK3-DAY3',
    'WEEK3-DAY4',
    'WEEK3-DAY5',
    'WEEK3',
    'WEEK4-DAY1',
    'WEEK4-DAY2',
    'WEEK4-DAY3',
    'WEEK4-DAY4',
    'WEEK4-DAY5',
    'WEEK4',
    'WEEK5-DAY1',
    'WEEK5-DAY2',
    'WEEK5-DAY3',
    'WEEK5-DAY4',
    'WEEK5-DAY5',
    'WEEK5',
]

groups = groupNamesInOrder.map(id => groups.find(e => e.id === id))
data.forEach(d => {
    d.groupIds = d.tags.map(t => groups.find(g => g.name === t).id)
    d.definitions = d.definitions.filter(def => def.definitionText)
    d.definitions.forEach(def => {
        def.examples = def.examples.filter(e => e)
        def.synonyms = def.synonyms.filter(e => e)
    })
})

const structuredData = {
    groups,
    words: data,
}

console.log(JSON.stringify(structuredData))