drawPredictions = ->
    $('.prediction-values').each ->
        $(this).children('.prediction-value').each ->
            timer = parseInt($(this).attr('data-value'))
            if timer < 0
                $(this).remove()
            else
                unit = if timer == 1 then 'minute' else 'minutes'
                $(this).text(timer + ' ' + unit)
                $(this).attr('data-value', timer - 1)
            return
        if $(this).children('.prediction-value').length == 0
            $(this).text('No predictions at this time.')
        return
    return

$(document).ready drawPredictions
setInterval drawPredictions, 60000
