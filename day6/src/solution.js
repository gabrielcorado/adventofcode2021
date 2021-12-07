const countLanternfish = (fishList, days) => {
  const reproducingStack = new Array(9).fill(0)
  for (fish of fishList) {
    reproducingStack[fish] += 1
  }

  for (let day = 0; day < days; day++) {
    const reproducing = reproducingStack.shift()
    reproducingStack.push(reproducing)
    reproducingStack[6] += reproducing
  }

  return reproducingStack.reduce((acc, count) => acc + count)
}

module.exports = { countLanternfish }
