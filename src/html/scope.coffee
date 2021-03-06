
alight.d.al.html.modifier.scope = (self, option) ->
    d = self.name.split ':'
    if d.length is 2
        self.name = d[0]
        outerName = d[1]
    else
        d = self.name.match /(.+)\:\s*\:\:([\d\w]+)$/
        if d
            oneTime = true
        else
            oneTime = false
            d = self.name.match /(.+)\:\s*([\.\w]+)$/
            if not d
                throw 'Wrong expression ' + self.name
        self.name = d[1]
        outerName = d[2]
    innerName = 'outer'

    self.insertBlock = (html) ->
        self.activeElement = self.baseElement.cloneNode false
        self.activeElement.innerHTML = html
        self.insertDom self.topElement, self.activeElement

        parentCD = option.env.changeDetector
        childCD = self.childCD = parentCD.new null,
            locals: true

        w = parentCD.watch outerName, (outerValue) ->
            childCD.locals[innerName] = outerValue
        ,
            oneTime: oneTime

        self.childCD.watch '$destroy', ->
            w.stop()

        alight.bind self.childCD, self.activeElement,
            skip_attr: option.env.skippedAttr()
        return
