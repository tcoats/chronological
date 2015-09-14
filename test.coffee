moment = require 'moment-timezone'
spanner = require 'timespanner'
chrono = require './'
moment  = chrono spanner moment

now = moment.utc()

iso8601 = 'YYYY-MM-DD[T]HH:mm:ssZ'

freq = moment.spanner('now/d').every(6, 'h')

console.log '-'
console.log moment.utc().format iso8601
console.log freq.between(
  moment.spanner('now/d/w-1s'),
  moment.spanner('now/d+1w/w')
).map (d) -> d.format iso8601