<register-entry class="h-100">
    <div class="container-fluid py-3 semi-trans">
        <div class="row">
            <div class="col-lg-6 col-md-8 col-sm-8 col-xs-8 mx-auto" style="margin-top: 5%;">
                <div class="card card-body">
                    <virtual if={(page.model && page.model.register && page.model.register.label && page.model.register.hint)}>
                        <h3 class="text-center mb-4 alert alert-success" role="alert">
                            {page.model.register.label.title}
                        </h3>
                        <fieldset>
                            <div class="form-group has-error">
                                <label for="customerName">&nbsp;{page.model.register.label.customerName}</label>
                                <input class="form-control input-lg" placeholder="{page.model.register.hint.customerName}" id="customerName" name="customerName" type="text">
                            </div>
                            <div class="form-group has-error">
                                <label for="userName">&nbsp;{page.model.register.label.userName}</label>
                                <input class="form-control input-lg" placeholder="{page.model.register.hint.userName}" id="userName" name="userName" type="email">
                            </div>
                            <div class="form-group has-success">
                                <label for="passWord">&nbsp;{page.model.register.label.passWord}</label>
                                <input class="form-control input-lg" placeholder="{page.model.register.hint.passWord}" id="passWord" name="passWord" value="" type="password">
                            </div>
                            <div class="form-group has-success">
                                <label for="confirnPassword">&nbsp;{page.model.register.label.confirmPassWord}</label>
                                <input class="form-control input-lg" placeholder="{page.model.register.hint.confirmPassWord}" id="confirnPassword" name="confirnPassword" value=""
                                    type="password">
                            </div>
                            <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="{onRegisterCustomer}">
                                <i class="fas fa-user-plus"></i>
                                {page.model.register.label.signUp}
                            </button>
                        </fieldset>
                    </virtual>
                </div>                
            </div>
        </div>
    </div>

    <style>
        :scope {
            width: 100%;
            height: 100%;
        }
        .semi-trans { opacity: 0.96; }
    </style>

    <script>
        //-- local variables.
        let self = this;
        this.tooltip = new BS4ToolTip();
        this.alert = new BS4Alert();
        
        //-- setup service handlers.        
        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);

        //-- private methods.
        this.validateInput = (customer) => {
            if (!customer) {
                this.alert.show(page.model.msg.customerIsNull);
                return false;
            }
            if (!customer.customerName || customer.customerName.trim() === '') {
                this.tooltip.show($('#customerName'), page.model.msg.customerNameRequired);
                return false;
            }
            if (!customer.userName || customer.userName.trim() === '') {
                this.tooltip.show('#userName', page.model.msg.userNameRequired);
                return false;
            }
            if (!nlib.utils.isValidEmail(customer.userName)) {
                this.tooltip.show('#userName', page.model.msg.userNameIsNotEmail);
                return false;
            }
            if (!customer.passWord || customer.passWord.trim() === '') {
                this.tooltip.show('#passWord', page.model.msg.passWordRequired);
                return false;
            }
            if (!customer.confirnPassword || customer.confirnPassword.trim() === '') {
                this.tooltip.show('#confirnPassword', page.model.msg.confirmPasswordRequired);
                return false;
            }
            if (customer.confirnPassword !== customer.passWord) {
                this.tooltip.show('#confirnPassword', page.model.msg.confirmPasswordMismatch);
                return false;
            }
            return true;
        };

        this.getCustomer = () => { 
            let customer = { 
                "langId": lang.langId, // current lang id.
                "customerName": $('#customerName').val(),
                "userName": $('#userName').val(), 
                "passWord": $('#passWord').val(),
                "confirnPassword": $('#confirnPassword').val()
            };
            return customer;
        };

        //-- click events
        this.onRegisterCustomer = (e) => {
            e.preventDefault();
            let customer = self.getCustomer();
            if (!self.validateInput(customer)) return;            
            secure.register(customer); // register customer.
        };
    </script>
    
</register-entry>