module.exports = (moment) => {
  if (moment.every != null) return moment
  const every = (anchor, count, unit) => {
    const res = {
      nth: (n) => anchor.clone().add(count * n, unit),
      anchor: anchor,
      count: (d) => {
        let diff = d.diff(anchor, unit, true)
        diff /= count
        return diff
      },
      after: (d) => {
        var diff
        diff = d.diff(anchor, unit, true)
        diff /= count
        diff = Math.ceil(diff)
        return res.nth(diff)
      },
      before: (d) => {
        let diff = d.diff(anchor, unit, true)
        diff /= count
        diff = Math.floor(diff)
        return res.nth(diff)
      },
      next: (d) => {
        const current = res.count(d)
        let next = Math.ceil(current)
        if (next === current) next++
        return next
      },
      prev: (d) => {
        const current = res.count(d)
        let prev = Math.floor(current)
        if (prev === current) prev--
        return prev
      },
      between: (start, end) => {
        if (start.isAfter(end)) [start, end] = [end, start]
        const startindex = Math.ceil(res.count(start))
        const endindex = res.prev(end)
        if (startindex > endindex) return []
        const results = []
        for (let i = startindex; i <= endindex; i++) results.push(i)
        return results.map(res.nth)
      },
      clone: () => {
        return anchor.clone().every(count, unit)
      },
      forward: (n) => anchor.add(count * n, unit),
      backward: (n) => anchor.subtract(count * n, unit),
      timer: (target, cb) => {
        if (cb == null) {
          cb = target
          target = res.next(moment.utc())
        }
        if (target == null) target = res.next(moment.utc())
        let timeout = null
        const tick = () => {
          var mstravel, next, now, target_time
          now = moment.utc()
          next = res.next(now)
          while (target < next) {
            cb(res.nth(target), target)
            target++
          }
          target_time = res.nth(target)
          mstravel = target_time.diff(now, 'ms')
          timeout = setTimeout(tick, Math.min(60000, mstravel + 1))
        }
        tick()
        return {
          end: () => {
            if (timeout == null) return
            clearTimeout(timeout)
            timeout = null
          }
        }
      }
    }
    return res
  }
  moment.every = (count, unit) => every(moment(), count, unit)
  const fn = moment.fn != null ? moment.fn : moment.default.fn
  fn.every = (count, unit) => every(this, count, unit)
  fn.timer = (cb) => {
    const target_time = this
    let timeout = null
    const tick = () => {
      var mstravel, now
      now = moment.utc()
      if (now.isAfter(target_time)) return cb(target_time)
      mstravel = target_time.diff(now, 'ms')
      timeout = setTimeout(tick, Math.min(60000, mstravel + 1))
    }
    timeout = setTimeout(tick, 1)
    return {
      cancel: () => {
        if (timeout == null) return
        clearTimeout(timeout)
        timeout = null
      }
    }
  }
  return moment
}
