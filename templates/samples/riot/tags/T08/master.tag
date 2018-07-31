<master class="h-100 container-fluid">
    <!--
    <ul class="nav nav-tabs">
        <li class="nav-item active"><a href="#">Home</a></li>
        <li class="nav-item dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">Menu 1
            <span class="caret"></span></a>
            <ul class="dropdown-menu">
            <li><a href="#">Submenu 1-1</a></li>
            <li><a href="#">Submenu 1-2</a></li>
            <li><a href="#">Submenu 1-3</a></li> 
            </ul>
        </li>
        <li class="nav-item"><a href="#">Menu 2</a></li>
        <li class="nav-item"><a href="#">Menu 3</a></li>
    </ul>
    -->
    <ul class="nav nav-tabs mb-3" id="pills-tab" role="tablist">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" 
                data-toggle="dropdown" role="button" 
                href="javascript:void(0);" aria-haspopup="true"
                aria-expanded="false" aria-selected="false">
                <span class="fas fa-plus"></span>
            </a>
            <ul class="dropdown-menu">
                <a class="dropdown-item active" href="javascript:void(0);">Thai</a>
                <a class="dropdown-item active" href="javascript:void(0);">German</a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="javascript:void(0);">English</a>
                <a class="dropdown-item" href="javascript:void(0);">Japanese</a>
            </ul>
        </li>
        <li class="nav-item">
            <a class="nav-link active" data-toggle="tab" role="tab"
                aria-controls="home-tab-panel" aria-selected="true"
                id="home-tab-header" href="#home-tab-panel">
                Flexbox
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-toggle="tab" role="tab" 
                aria-controls="profile-tab-panel" aria-selected="false"
                id="profile-tab-header" href="#profile-tab-panel">
                Card/div scrollable
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-toggle="tab" role="tab" 
                aria-controls="contact-tab-panel" aria-selected="false" 
                id="contact-tab-header" href="#contact-tab-panel">
                Contact
            </a>
        </li>
    </ul>
    <div class="tab-content" id="tabContent">
        <div class="tab-pane fade show active" role="tabpanel"
            aria-labelledby="home-tab-header"
            id="home-tab-panel">
            <h3>Basic Bootstrap 4 Flexbox layout.</h3>
            <p><b>1. flexbox container.</b></p>
            <div class="d-flex p-2 show-border">
                I'm a flexbox container!
            </div>
            <br/>
            <p><b>2. inline flexbox container.</b></p>
            <div class="d-inline-flex p-2 show-border">
                I'm an inline flexbox container!
            </div>
            <br/>
            <br/>
            <p><b>3. set the direction of flex items in a flex container.</b></p>
            <p>3.1. set a direction normal.</p>
            <div class="d-flex flex-row show-border">
                <div class="p-2 show-border">Flex item 1</div>
                <div class="p-2 show-border">Flex item 2</div>
                <div class="p-2 show-border">Flex item 3</div>
            </div>
            <br/>
            <p>3.2. set a direction reverse.</p>
            <div class="d-flex flex-row-reverse show-border">
                <div class="p-2 show-border">Flex item 1</div>
                <div class="p-2 show-border">Flex item 2</div>
                <div class="p-2 show-border">Flex item 3</div>
            </div>
            <br/>
            <br/>
            <p><b>4. set a vertical direction.</b></p>
            <p>4.1. set a vertical direction normal.</p>
            <div class="d-flex flex-column show-border">
                <div class="p-2 show-border">Flex item 1</div>
                <div class="p-2 show-border">Flex item 2</div>
                <div class="p-2 show-border">Flex item 3</div>
            </div>
            <br/>
            <p>4.2. set a vertical direction reverse.</p>
            <div class="d-flex flex-column-reverse show-border">
                <div class="p-2 show-border">Flex item 1</div>
                <div class="p-2 show-border">Flex item 2</div>
                <div class="p-2 show-border">Flex item 3</div>
            </div>
            <br/>
            <p><b>5. align items.</b></p>
            <p>5.1. align items stretch.</p>
            <div class="d-flex align-items-stretch show-border">
                <div class="p-2 show-border">
                    <h1>Flex item 1</h1>
                </div>
                <div class="p-2 show-border">
                    Flex item 2
                </div>
                <div class="p-2 show-border">
                    <div style="font-size:5em;">Flex item 3</div>
                </div>
            </div>
            <br/>
            <p>5.2. align items stretch with align vertical by use m-auto on each item.</p>
            <div class="d-flex align-items-stretch show-border">
                <div class="p-2 m-auto show-border">
                    <h1>Flex item 1</h1>
                </div>
                <div class="p-2 m-auto show-border">
                    Flex item 2
                </div>
                <div class="p-2 m-auto show-border">
                    <div style="font-size:5em;">Flex item 3</div>
                </div>
            </div>
            <br/>
            <p><b>6. align self.</b></p>
            <p>6.1. align self start.</p>
            <div class="d-flex flex-row show-border">
                <div class="p-4 show-border">Flex item 1</div>
                <div class="align-self-start show-border">Flex item 2</div>
                <div class="p-4 show-border">Flex item 3</div>
            </div>
            <br/>
            <p>6.2. align self end.</p>
            <div class="d-flex flex-row show-border">
                <div class="p-4 show-border">Flex item 1</div>
                <div class="align-self-end show-border">Flex item 2</div>
                <div class="p-4 show-border">Flex item 3</div>
            </div>
            <br/>
            <p>6.3. align self center.</p>
            <div class="d-flex flex-row show-border">
                <div class="p-4 show-border">Flex item 1</div>
                <div class="align-self-center show-border">Flex item 2</div>
                <div class="p-4 show-border">Flex item 3</div>
            </div>
            <br/>
            <p>6.4. align self baseline.</p>
            <div class="d-flex flex-row show-border">
                <div class="p-4 show-border">Flex item 1</div>
                <div class="align-self-baseline show-border">Flex item 2</div>
                <div class="p-4 show-border">Flex item 3</div>
            </div>
            <br/>
            <p>6.5. align self stretch.</p>
            <div class="d-flex flex-row show-border">
                <div class="p-4 show-border">Flex item 1</div>
                <div class="align-self-stretch show-border">Flex item 2</div>
                <div class="p-4 show-border">Flex item 3</div>
            </div>
            <br/>
            <p><b>7. auto margins</b></p>
            <p>7.1. no auto margin.</p>
            <div class="d-flex show-border">
                <div class="p-2 show-border">Flex item 1</div>
                <div class="p-2 show-border">Flex item 2</div>
                <div class="p-2 show-border">Flex item 3</div>
                <div class="p-2 show-border">Flex item 4</div>
            </div>
            <br/>
            <p>7.2. The second item auto push other item after itself to right.</p>
            <div class="d-flex show-border">
                <div class="p-2 show-border">Flex item 1</div>
                <div class="mr-auto p-2 show-border">Flex item 2</div>
                <div class="p-2 show-border">Flex item 3</div>
                <div class="p-2 show-border">Flex item 4</div>
            </div>
            <br/>
            <p>7.3. second to last item auto push other item before itself to left.</p>
            <div class="d-flex show-border">
                <div class="p-2 show-border">Flex item 1</div>
                <div class="p-2 show-border">Flex item 2</div>
                <div class="ml-auto p-2 show-border">Flex item 3</div>
                <div class="p-2 show-border">Flex item 4</div>
            </div>
            <br/>
            <p><b>8. vertically move one flex item to the top or bottom of a container.</b></p>
            <p>8.1. move fist item to top by use mb-auto.</p>
            <div class="d-flex align-items-start flex-column show-border" style="height: 200px;">
                <div class="mb-auto p-2 show-border">Flex item</div>
                <div class="p-2 show-border">Flex item</div>
                <div class="p-2 show-border">Flex item</div>
            </div>
            <br/>
            <p>8.2. move last item bottom by use mt-auto.</p>
            <div class="d-flex align-items-end flex-column show-border" style="height: 200px;">
                <div class="p-2 show-border">Flex item</div>
                <div class="p-2 show-border">Flex item</div>
                <div class="mt-auto p-2 show-border">Flex item</div>
            </div>
            <br/>
            <p><b>8. wrap.</b></p>
            <div class="d-flex flex-wrap">
                <div class="p-2 show-border">Flex item 0</div>
                <div class="p-2 show-border">Flex item 1</div>
                <div class="p-2 show-border">Flex item 2</div>
                <div class="p-2 show-border">Flex item 3</div>
                <div class="p-2 show-border">Flex item 4</div>
                <div class="p-2 show-border">Flex item 5</div>
                <div class="p-2 show-border">Flex item 6</div>
                <div class="p-2 show-border">Flex item 7</div>
                <div class="p-2 show-border">Flex item 8</div>
                <div class="p-2 show-border">Flex item 9</div>
                <div class="p-2 show-border">Flex item 10</div>
                <div class="p-2 show-border">Flex item 11</div>
                <div class="p-2 show-border">Flex item 12</div>
                <div class="p-2 show-border">Flex item 13</div>
                <div class="p-2 show-border">Flex item 14</div>
                <div class="p-2 show-border">Flex item 15</div>
                <div class="p-2 show-border">Flex item 16</div>
                <div class="p-2 show-border">Flex item 17</div>
                <div class="p-2 show-border">Flex item 18</div>
                <div class="p-2 show-border">Flex item 19</div>
                <div class="p-2 show-border">Flex item 20</div>
                <div class="p-2 show-border">Flex item 21</div>
                <div class="p-2 show-border">Flex item 22</div>
                <div class="p-2 show-border">Flex item 23</div>
                <div class="p-2 show-border">Flex item 24</div>
                <div class="p-2 show-border">Flex item 25</div>
                <div class="p-2 show-border">Flex item 26</div>
                <div class="p-2 show-border">Flex item 27</div>
                <div class="p-2 show-border">Flex item 28</div>
                <div class="p-2 show-border">Flex item 29</div>
            </div>
            <br/>
            <br/>
        </div>
        <div class="tab-pane m-auto fade" role="tabpanel"
            aria-labelledby="profile-tab-header"
            id="profile-tab-panel">
            <div data-is="scrollable-left" />
        </div>
        <div class="tab-pane m-auto fade" role="tabpanel"
            aria-labelledby="contact-tab-header"
            id="contact-tab-panel">
            Content 3
        </div>
    </div>
    <style>
        .show-border {
            border: 1px solid #ACDC12;
            background-color: seashell;
        }
        /*
        .tab-content {
            display: flex;
        }
        .tab-content .tab-pane {
            flex: 1;
            background-color: silver;
        }
        */
    </style>
    <script>
    </script>
</master>

<scrollable-left class="d-flex flex-column">
    <div class="flex-main d-flex mb-3">
        <div class="container-fluid d-flex">
            <div class="row">
                <div class="col-6 d-flex flex-column">
                    <div class="card">
                        <div class="list-group list-group-flush scrollable">
                            <a href="#" class="list-group-item list-group-item-action">
                                <b>FIRST LINK</b>
                            </a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action">Dapibus ac facilisis in</a>
                            <a href="#" class="list-group-item list-group-item-action">Morbi leo risus</a>
                            <a href="#" class="list-group-item list-group-item-action">Porta ac consectetur ac</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">Vestibulum at eros</a>
                            <a href="#" class="list-group-item list-group-item-action disabled">
                                <b>LAST LINK</b>
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="col-6 pr-3 scrollable">
                    <h1>FIRST LINE</h1> So many words, so many words. So many words, so many words. So many words, so many
                    words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br> So many words, so many words. So many words, so many words. So many words, so many words.
                    <br>
                    <h1>LAST LINE</h1>
                </div>

            </div>
        </div>
    </div>

    <style>
        /* Logic */
        :scope {
            min-height: 90vh;
        }
        .flex-main { flex: 1 1 0; }
        .scrollable { overflow-y: auto; }
    </style>
</scrollable-left>