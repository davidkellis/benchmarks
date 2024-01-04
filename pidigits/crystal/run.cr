require "big"

class PiDigitSpigot 
    @z: Transformation
    @x: Transformation
    @inverse: Transformation
    @y: BigInt = 0.to_big_i
 
    def initialize()
        @z = Transformation.new(1.to_big_i,0.to_big_i,0.to_big_i,1.to_big_i)
        @x = Transformation.new(0.to_big_i,0.to_big_i,0.to_big_i,0.to_big_i)
        @inverse = Transformation.new(0.to_big_i,0.to_big_i,0.to_big_i,0.to_big_i)
    end

    def next!
        @y = @z.extract(3) 
        if safe?(@y)
            @z = produce(@y)
            @y
        else 
            @z = consume(@x.next!())
            next!()
        end
    end

    def safe?(digit)
        digit == @z.extract(4)
    end

    def produce(i)
        @inverse.qrst(10.to_big_i,-10*i,0.to_big_i,1.to_big_i).compose(@z)
    end

    def consume(a)
        @z.compose(a)
    end
end


class Transformation 
    @q: BigInt
    @r: BigInt
    @s: BigInt
    @t: BigInt
    @k: BigInt

    getter :q, :r, :s, :t

    def initialize(q, r, s, t)
        @q,@r,@s,@t,@k = q,r,s,t,0.to_big_i
    end
    
    def next!()
        @q = @k = @k + 1
        @r = 4 * @k + 2
        @s = 0.to_big_i
        @t = 2 * @k + 1
        self
    end

    def extract(j)
        (@q * j + @r) / (@s * j + @t)
    end
    
    def compose(a)
        Transformation.new( @q * a.q,
                        @q * a.r + r * a.t,
                        @s * a.q + t * a.s,
                        @s * a.r + t * a.t
                    ) 
    end
    
    def qrst(*args)
        initialize(*args)
        self
    end

    
end


WIDTH = 10
n = (ARGV[0]? || 10000).to_i
j = 0

digits = PiDigitSpigot.new

while n > 0
    if n >= WIDTH
        WIDTH.times {print digits.next!}
        j += WIDTH
    else 
        n.times {print digits.next!}
        (WIDTH-n).times {print " "} 
        j += n
    end
    puts "\t:"+j.to_s
    n -= WIDTH
end
