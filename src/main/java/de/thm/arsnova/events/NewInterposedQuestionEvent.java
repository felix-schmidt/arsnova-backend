/*
 * This file is part of ARSnova Backend.
 * Copyright (C) 2012-2015 The ARSnova Team
 *
 * ARSnova Backend is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * ARSnova Backend is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package de.thm.arsnova.events;

import de.thm.arsnova.entities.InterposedQuestion;
import de.thm.arsnova.entities.Session;

public class NewInterposedQuestionEvent extends NovaEvent {

	private static final long serialVersionUID = 1L;

	private final Session session;
	private final InterposedQuestion question;

	public NewInterposedQuestionEvent(Object source, InterposedQuestion question, Session session) {
		super(source);
		this.question = question;
		this.session = session;
	}

	public Session getSession() {
		return session;
	}

	public InterposedQuestion getQuestion() {
		return question;
	}

	@Override
	public void accept(NovaEventVisitor visitor) {
		visitor.visit(this);
	}

}
