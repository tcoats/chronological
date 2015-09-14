module.exports = (moment) ->
  return moment if moment.every?

  every = (anchor, count, unit) ->
    res =
      nth: (n) ->
        anchor.clone().add count * n, unit
      anchor: anchor
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
      next: (d) ->
        current = res.count d
        next = Math.ceil current
        if next is current
          next++
        next
      prev: (d) ->
        current = res.count d
        prev = Math.floor current
        if prev is current
          prev--
        prev
      between: (start, end) ->
        if start.isAfter end
          [start, end] = [end, start]
        startindex = res.next start
        endindex = res.prev end
        return [] if startindex > endindex
        [startindex..endindex].map res.nth
      clone: ->
        anchor.clone().every count, unit
      forward: (n) ->
        anchor.add count * n, unit
      backward: (n) ->
        anchor.subtract count * n, unit
      timer: (target, cb) ->
        if !cb?
          cb = target
          # find the next target
          target = res.next moment.utc()
        timeout = null
        tick = ->
          now = moment.utc()
          next = res.next now
          # execute all iterations we may have missed
          while target < next
            cb res.nth(target), target
            target++
          target_time = res.nth target
          mstravel = target_time.diff now, 'ms'
          # maximum 1 minute time travel to prevent clock skew
          # travel to the millisecond after the target
          timeout = setTimeout tick, Math.min 60000, mstravel + 1
        tick()

        end: ->
          return if !timeout?
          clearTimeout timeout
          timeout = null
    res

  moment.every = (count, unit) ->
    every moment(), count, unit

  moment.fn.every = (count, unit) ->
    every @, count, unit

  moment