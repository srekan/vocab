const week1 = require('./weeks/week1.json')
const week2 = require('./weeks/week2.json')
const week3 = require('./weeks/week3.json')
const week4 = require('./weeks/week4.json')
const week5 = require('./weeks/week5.json')
const week6 = require('./weeks/week6.json')
const week7 = require('./weeks/week7.json')
const week8 = require('./weeks/week8.json')

function updateDayGroups(week, weekName) {
    weekName = weekName.toUpperCase().replace(' ', '')
    week.forEach(w => {
        w.definitions = [w.definitions[0]]
        w.tags = w.tags.map(t => {
            const tag = t.toUpperCase().replace(' ', '')
            if (tag.indexOf('DAY') !== -1) {
                return `${weekName.toUpperCase()}-${tag}`
            }

            return tag.toUpperCase()
        });
    });
}

updateDayGroups(week1, 'Week 1')
updateDayGroups(week2, 'Week 2')
updateDayGroups(week3, 'Week 3')
updateDayGroups(week4, 'Week 4')
updateDayGroups(week5, 'Week 5')
updateDayGroups(week6, 'Week 6')
updateDayGroups(week7, 'Week 7')
updateDayGroups(week8, 'Week 8')
const weeks = [
    ...week1,
    ...week2,
    ...week3,
    ...week4,
    ...week5,
    ...week6,
    ...week7,
    ...week8,
]
// console.log(JSON.stringify(weeks))
module.exports = weeks
