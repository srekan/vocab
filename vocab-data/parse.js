const _ = require('lodash')
const moment = require('moment')
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
        displayName = `${t} Assesment`
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

const groupsInOrder = [
    { id: 'WEEK1-DAY1', globalGroupId: 'WEEK1-GLOBAL' },
    { id: 'WEEK1-DAY2', globalGroupId: 'WEEK1-GLOBAL' },
    { id: 'WEEK1-DAY3', globalGroupId: 'WEEK1-GLOBAL' },
    { id: 'WEEK1-DAY4', globalGroupId: 'WEEK1-GLOBAL' },
    { id: 'WEEK1-DAY5', globalGroupId: 'WEEK1-GLOBAL' },
    { id: 'WEEK1', globalGroupId: 'WEEK1-GLOBAL' },
    { id: 'WEEK2-DAY1', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK2-DAY2', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK2-DAY3', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK2-DAY4', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK2-DAY5', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK2', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK3-DAY1', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK3-DAY2', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK3-DAY3', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK3-DAY4', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK3-DAY5', globalGroupId: 'WEEK2-GLOBAL' },
    { id: 'WEEK3', globalGroupId: 'WEEK3-GLOBAL' },
    { id: 'WEEK4-DAY1', globalGroupId: 'WEEK4-GLOBAL' },
    { id: 'WEEK4-DAY2', globalGroupId: 'WEEK4-GLOBAL' },
    { id: 'WEEK4-DAY3', globalGroupId: 'WEEK4-GLOBAL' },
    { id: 'WEEK4-DAY4', globalGroupId: 'WEEK4-GLOBAL' },
    { id: 'WEEK4-DAY5', globalGroupId: 'WEEK4-GLOBAL' },
    { id: 'WEEK4', globalGroupId: 'WEEK4-GLOBAL' },
    { id: 'WEEK5-DAY1', globalGroupId: 'WEEK5-GLOBAL' },
    { id: 'WEEK5-DAY2', globalGroupId: 'WEEK5-GLOBAL' },
    { id: 'WEEK5-DAY3', globalGroupId: 'WEEK5-GLOBAL' },
    { id: 'WEEK5-DAY4', globalGroupId: 'WEEK5-GLOBAL' },
    { id: 'WEEK5-DAY5', globalGroupId: 'WEEK5-GLOBAL' },
    { id: 'WEEK5', globalGroupId: 'WEEK5-GLOBAL' },
    { id: 'WEEK6-DAY1', globalGroupId: 'WEEK6-GLOBAL' },
    { id: 'WEEK6-DAY2', globalGroupId: 'WEEK6-GLOBAL' },
    { id: 'WEEK6-DAY3', globalGroupId: 'WEEK6-GLOBAL' },
    { id: 'WEEK6-DAY4', globalGroupId: 'WEEK6-GLOBAL' },
    { id: 'WEEK6-DAY5', globalGroupId: 'WEEK6-GLOBAL' },
    { id: 'WEEK6', globalGroupId: 'WEEK6-GLOBAL' },
    { id: 'WEEK7-DAY1', globalGroupId: 'WEEK7-GLOBAL' },
    { id: 'WEEK7-DAY2', globalGroupId: 'WEEK7-GLOBAL' },
    { id: 'WEEK7-DAY3', globalGroupId: 'WEEK7-GLOBAL' },
    { id: 'WEEK7-DAY4', globalGroupId: 'WEEK7-GLOBAL' },
    { id: 'WEEK7-DAY5', globalGroupId: 'WEEK7-GLOBAL' },
    { id: 'WEEK7', globalGroupId: 'WEEK7-GLOBAL' },
]
groups = groupsInOrder.map(g => {
    const group = groups.find(e => e.id === g.id)
    group.globalGroupId = g.globalGroupId
    return group
})
const globalGroups = [
    {
        id: 'WEEK1-GLOBAL',
        displayName: 'Week1',
        subGroupIds: [
            'WEEK1-DAY1',
            'WEEK1-DAY2',
            'WEEK1-DAY3',
            'WEEK1-DAY4',
            'WEEK1-DAY5',
            'WEEK1',
        ]
    },
    {
        id: 'WEEK2-GLOBAL',
        displayName: 'Week 2',
        subGroupIds: [
            'WEEK2-DAY1',
            'WEEK2-DAY2',
            'WEEK2-DAY3',
            'WEEK2-DAY4',
            'WEEK2-DAY5',
            'WEEK2',
        ],
    },
    {
        id: 'WEEK3-GLOBAL',
        displayName: 'Week 3',
        subGroupIds: [
            'WEEK3-DAY1',
            'WEEK3-DAY2',
            'WEEK3-DAY3',
            'WEEK3-DAY4',
            'WEEK3-DAY5',
            'WEEK3',
        ],
    },
    {
        id: 'WEEK4-GLOBAL',
        displayName: 'Week 4',
        subGroupIds: [
            'WEEK4-DAY1',
            'WEEK4-DAY2',
            'WEEK4-DAY3',
            'WEEK4-DAY4',
            'WEEK4-DAY5',
            'WEEK4',
        ],
    },
    {
        id: 'WEEK5-GLOBAL',
        displayName: 'Week 5',
        subGroupIds: [
            'WEEK5-DAY1',
            'WEEK5-DAY2',
            'WEEK5-DAY3',
            'WEEK5-DAY4',
            'WEEK5-DAY5',
            'WEEK5',
        ],
    },
    {
        id: 'WEEK6-GLOBAL',
        displayName: 'Week 6',
        subGroupIds: [
            'WEEK6-DAY1',
            'WEEK6-DAY2',
            'WEEK6-DAY3',
            'WEEK6-DAY4',
            'WEEK6-DAY5',
            'WEEK6',
        ],
    },
    {
        id: 'WEEK7-GLOBAL',
        displayName: 'Week 7',
        subGroupIds: [
            'WEEK7-DAY1',
            'WEEK7-DAY2',
            'WEEK7-DAY3',
            'WEEK7-DAY4',
            'WEEK7-DAY5',
            'WEEK7',
        ],
    },
]
data.forEach(d => {
    d.groupIds = d.tags.map(t => groups.find(g => g.name === t).id)
    d.definitions = d.definitions.filter(def => def.definitionText)
    d.definitions.forEach(def => {
        def.examples = def.examples.filter(e => e)
        def.synonyms = def.synonyms.filter(e => e)
    })
})

const structuredData = {
    version: moment().format('YYYY-MM-DD-hh:mm:ss'),
    globalGroups,
    groups,
    words: data,
}

console.log(JSON.stringify(structuredData))