var someonesCar = {
    color: 'silver',
    odometer: 65653,
    mpgHighway: 3.5,
    mpgCity: 6.6,
    make: 'Buick',
    model: 'Century Custom',
    isPristine: false,
    battleDamage: [
      '2 inch gash all along the left side',
      'tear in seat cover in rear-driver side seat',
      'dented front right bumper'
    ]
  }
var outputElement = document.getElementById('output')
var buttonElement = document.getElementById('boom')
var clickCount = 0
var clickHandler = function (event) {
    console.log(
        'The Button was Clicked. This is the event object',
        event
    )
    outputElement.innerHTML += '\n' + clickCount
    clickCount += 1
}
buttonElement.addEventListener('click', clickHandler)
var jsonString = JSON.stringify(someonesCar, null, '  ')

outputElement.innerHTML = jsonString

console.log('the someonesCar object', someonesCar)