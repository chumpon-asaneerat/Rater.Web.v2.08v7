<master class="h-100">
    <div class="container-fluid py-3 semi-trans">
        <div class="row">
            <div class="col-lg-6 col-md-8 col-sm-8 col-xs-8 mx-auto" style="margin-top: 10%;">
                <div class="card card-body">
                    <h3 class="text-center mb-4">Register</h3>
                    <fieldset>
                        <div class="form-group has-error">
                            <label for="customerName">&nbsp;Customer Name.</label>
                            <input class="form-control input-lg" placeholder="Customer Name." id="customerName" name="customerName" type="text">
                        </div>
                        <div class="form-group has-error">
                            <label for="userName">&nbsp;User Name.</label>
                            <input class="form-control input-lg" placeholder="Use E-mail Address as User Name." id="userName" name="userName" type="email">
                        </div>
                        <div class="form-group has-success">
                            <label for="passWord">&nbsp;Password.</label>
                            <input class="form-control input-lg" placeholder="Password." id="passWord" name="passWord" value="" type="password">
                        </div>
                        <div class="form-group has-success">
                            <label for="confirnPassword">&nbsp;Confirm Password.</label>
                            <input class="form-control input-lg" placeholder="Confirm Password." id="confirnPassword" name="confirnPassword" value="" type="password">
                        </div>
                        <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="{onsubmit}">
                            <i class="fas fa-user-plus"></i>
                            Sign Up
                        </button>
                    </fieldset>
                </div>                
            </div>
        </div>
    </div>

    <style>
        :scope {
            width: 100%;
            height: 100%;
            background-image: url('images/register-bg.png');
            background-repeat: no-repeat;
            background-size: 100%;
        }

        .semi-trans {
            opacity: 0.97;
        }
    </style>

    <script>
        this.onsubmit = function(e) {
            e.preventDefault();
            let user = {
                customerName: $('#customerName').val(),
                userName: $('#userName').val(),
                passWord: $('#passWord').val(),
                confirnPassword: $('#confirnPassword').val()
            };
            console.log(user);
        }
    </script>
</master>