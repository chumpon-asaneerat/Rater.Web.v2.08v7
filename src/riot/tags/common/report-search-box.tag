<report-search-box>
    <div>
        <div>
            <input type="text">
        </div>
        <!--
        <div class="tag-box">
            <a href="#"><span class="tag-clear"></span></a>
            <span class="tag-caption">Question set</span>            
            <span class="tag-item">Question set 1.<span class="tag-close"></span></span>
        </div>
        -->
        <!--
        <div class="tag-box">
            <a href="#"><span class="tag-clear"></span></a>
            <span class="tag-caption">Question</span>            
            <span class="tag-item">1. What do you think about our service?<span class="tag-close"></span></span>
            <span class="tag-item">3. What do you think about our food quality?<span class="tag-close"></span></span>            
        </div>
        -->
        <div class="tag-box">
            <a href="#"><span class="tag-clear"></span></a>
            <span class="tag-caption">Orgs</span>
            <span class="tag-item">Softbase<span class="tag-close"></span></span>
            <span class="tag-item">Marketing<span class="tag-close"></span></span>
            <span class="tag-item">Account<span class="tag-close"></span></span>
            <span class="tag-item">Manufacture<span class="tag-close"></span></span>
            <span class="tag-item">Support<span class="tag-close"></span></span>
            <span class="tag-item">Finance<span class="tag-close"></span></span>
            <span class="tag-item">Perchasing<span class="tag-close"></span></span>
            <span class="tag-item">Audit<span class="tag-close"></span></span>
            <span class="tag-item">PR<span class="tag-close"></span></span>
            <span class="tag-item">Housekeeping<span class="tag-close"></span></span>
            <span class="tag-item">Counter 1F<span class="tag-close"></span></span>
            <span class="tag-item">Counter 2F<span class="tag-close"></span></span>
            <span class="tag-item">Counter 3F<span class="tag-close"></span></span>
            <span class="tag-item">Counter 4F<span class="tag-close"></span></span>
        </div>
        <div class="tag-box">
            <a href="#"><span class="tag-clear"></span></a>
            <span class="tag-caption">Staff</span>
            <span class="tag-item">Mr. Administrator<span class="tag-close"></span></span>
            <span class="tag-item">Mr. Chumpon Asaneerat<span class="tag-close"></span></span>
            <!--
            <span class="tag-item">Mr. Thana Phorchan<span class="tag-close"></span></span>
            -->
        </div>
        <!--
        <div class="tag-box">
            <a href="#"><span class="tag-clear"></span></a>
            <span class="tag-caption">Date</span>            
            <span class="tag-item">2018-08-01 - 2018-09-30</span>
        </div>
        -->
    </div>
    <style>
        :scope {
            margin: 0 auto;
            padding: 15px;
            font-size: 14px;
        }

        input[type='text'] {
            display: inline-block;
            margin: 0 auto;
            width: 100%;
        }

        .tag-box {
            display: block;
            margin: 0 auto;
            padding: 2px;
        }

        .tag-box .tag-caption {
            display: inline-block;
            margin: 1px auto;
            padding: 1px 8px;
            color: whitesmoke;
            background-color: cornflowerblue;
            border-radius: 5px;
            width: 100px;
            min-width: 100px;
            text-align: right;
            /* font-weight: bold; */
        }

        .tag-box .tag-clear {
            display: inline-block;
            box-sizing: border-box;
            vertical-align: middle;
            margin: 0 auto;
            margin-top: -3px;
            margin-left: 0.3em;
            width: 15px;
            height: 15px;
            border-width: 3px;
            border-style: solid;
            border-color: red;
            border-radius: 100%;
            background: linear-gradient(-45deg, transparent 0%, transparent 46%, white 46%, white 56%, transparent 56%, transparent 100%), linear-gradient(45deg, transparent 0%, transparent 46%, white 46%, white 56%, transparent 56%, transparent 100%);
            background-color: red;
            box-shadow: 0px 0px 3px 1px rgba(0, 0, 0, 0.5);
            transition: all 0.3s ease;
        }

        .tag-box .tag-item {
            display: inline-block;
            margin: 2px auto;
            padding: 1px 5px;
            color: whitesmoke;
            /* font-weight: bold; */
            background-color: #119911;
            border-radius: 5px;
        }

        .tag-box .tag-item .tag-close {
            display: inline-block;
            margin-top: 0px;
            margin-left: 0.5em;
            margin-right: 0.3em;
            transform: scale(1, 0.8);
            transition: all 0.3s ease;
            text-decoration: none;
            color: whitesmoke;
        }

        .tag-box .tag-item .tag-close::after {
            content: 'x';
        }

        .tag-box .tag-item .tag-close:hover {
            cursor: pointer;
            color: red;
        }
    </style>
    <script>
        let self = this;
    </script>
</report-search-box>