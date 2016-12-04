import ReactDOM from 'react-dom';
import React from 'react';
import Knob from 'jquery-knob';
import Widget from '../../assets/javascripts/widget';
import {updatedAt} from '../../assets/javascripts/helpers';

import './meter.scss';

Widget.mount(class Meter extends Widget {
  componentDidMount() {
    this.state = { value: 0 };
    this.$node = $(ReactDOM.findDOMNode(this));
    this.$meter = this.$node.find('.meter');
    this.$meter.attr('data-bgcolor', this.$meter.css('background-color'));
    this.$meter.attr('data-fgcolor', this.$meter.css('color'));
    this.$meter.knob();
  }
  componentDidUpdate() {
    this.$meter.val(this.state.value);
    this.$meter.trigger('change');
  }
  render() {
    return (
      <div className={this.props.className}>
        <h1 className="title">{this.props.title}</h1>
        <input value="0"
               className="meter"
               readOnly="readonly"
               data-min={this.props.min}
               data-max={this.props.max}
               data-step={this.props.step}
               data-angleoffset="-125"
               data-anglearc="250"
               data-width="200"/>
        <p className="updated-at">{updatedAt(this.state.updated_at)}</p>
      </div>
    );
  }
});
