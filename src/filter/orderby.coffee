
# | orderBy: key, reverse
alight.filters.orderBy = class O
    constructor: (exp, scope) ->
        that = @
        d = exp.split ','

        @.list = null
        key = 'key'
        direction = 1

        sortFn = (a, b) ->
            va = a[key] or null
            vb = b[key] or null
            if va < vb
                return -direction
            if va > vb
                return direction
            return 0

        that.doSort = ->
            if that.list instanceof Array
                that.list.sort sortFn
                that.setValue that.list

        # key
        if d[0]
            scope.$watch d[0].trim(), (v) ->
                key = v
                that.doSort()

        # reverse
        if d[1]
            scope.$watch d[1].trim(), (v) ->
                direction = if v then 1 else -1
                that.doSort()

    onChange: (input) ->
        if input instanceof Array
            @.list = input.slice()
        else
            @.list = null
        @.doSort()