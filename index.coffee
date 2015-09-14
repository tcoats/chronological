module.exports = (moment) ->
  return moment if moment.every?

  every = (anchor, count, unit) ->
    res =
      nth: (n) ->
        anchor.clone().add count * n, unit
      count: (d) ->
        diff = d.diff anchor, unit, yes
        diff /= count
        diff
      after: (d) ->
        diff = d.diff anchor, unit, yes
        diff /= count
        diff = Math.ceil diff
        res.nth diff
      before: (d) ->
        diff = d.diff anchor, unit, yes
        diff /= count
        diff = Math.floor diff
        res.nth diff
      between: (start, end) ->
        if start.isAfter end
          [start, end] = [end, start]
        startindex = res.count start
        nextstartindex = Math.ceil startindex
        if nextstartindex is startindex
          nextstartindex++
        endindex = res.count end
        prevendindex = Math.floor endindex
        if prevendindex is endindex
          prevendindex--
        return [] if nextstartindex > prevendindex
        [nextstartindex..prevendindex].map res.nth
      clone: ->
        anchor.clone().every count, unit
      forward: (n) ->
        anchor.add count * n, unit
      backward: (n) ->
        anchor.subtract count * n, unit
    res

  moment.every = (count, unit) ->
    every moment(), count, unit

  moment.fn.every = (count, unit) ->
    every @, count, unit

  moment