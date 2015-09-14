# Chronological
Cron-like time schedule format and calculator

Using a starting anchor, iterates by a number of units. Units are the same as provided to [moment.add](http://momentjs.com/docs/#/manipulating/add/).

# Usage
```js
var moment = require('moment');
var chrono = require('chronological');

moment = chrono(moment);

var iso8601 = 'YYYY-MM-DD[T]HH:mm:ssZ';

var startofday = moment.utc().startOf('day');
var everyday = startofday.every(1, 'day');

var daysinmonth = everyday.between(
    moment.utc().startOf('month').subtract(1, 'second'),
    moment.utc().endOf('month').add(1, 'second')
);
daysinmonth.forEach(function (d) {
    console.log(d.format(iso8601));
});

var firstdayafternow = everyday.after(moment.utc());
console.log(firstdayafternow.format(iso8601));

var firstdaybeforenow = everyday.before(moment.utc());
console.log(firstdaybeforenow.format(iso8601));
```